use convert_case::{Case, Casing};
use octocrab::{models::Repository, Octocrab};
use serde::{Deserialize, Serialize};
use serde_with::{serde_as, OneOrMany};
use std::path::Path;
use std::{collections::HashMap, fs::File, process::Command};
use tokio::join;

#[derive(Serialize, Deserialize)]
struct Blacklist {
    repos: Vec<String>,
}
#[derive(Serialize, Deserialize)]
struct Prefetch {
    hash: String,
}
#[derive(Serialize, Deserialize, Clone)]
struct FetchURL {
    url: String,
    hash: String,
}

// Extension
#[serde_as]
#[derive(Clone, Serialize, Deserialize, Debug)]
struct ExtManifests(#[serde_as(as = "OneOrMany<_>")] Vec<ExtManifest>);

#[derive(Clone, Debug, Serialize, Deserialize)]
struct ExtManifest {
    name: String,
    main: String,
    branch: Option<String>,
}

#[derive(Serialize, Deserialize)]
struct ExtTuple {
    manifests: ExtManifests,
    repo: Repository,
}

#[derive(Serialize, Deserialize)]
struct ExtOutput {
    name: String,
    main: String,
    source: FetchURL,
}

// App
#[derive(Clone, Debug, Serialize, Deserialize)]
struct AppManifest {
    name: String,
    branch: Option<String>,
}

#[serde_as]
#[derive(Clone, Serialize, Deserialize, Debug)]
struct AppManifests(#[serde_as(as = "OneOrMany<_>")] Vec<AppManifest>);

#[derive(Serialize, Deserialize)]
struct AppTuple {
    manifests: AppManifests,
    repo: Repository,
}

#[derive(Serialize, Deserialize)]
struct AppOutput {
    name: String,
    source: FetchURL,
}

// Theme
#[derive(Serialize, Deserialize)]
#[serde(untagged)]
enum IncludeEnum {
    String(String),
    FetchURL(FetchURL),
}

#[derive(Clone, Debug, Serialize, Deserialize)]
struct ThemeManifest {
    name: String,
    usercss: String,
    schemes: String,
    include: Option<Vec<String>>,
    branch: Option<String>,
}

#[serde_as]
#[derive(Clone, Serialize, Deserialize, Debug)]
struct ThemeManifests(#[serde_as(as = "OneOrMany<_>")] Vec<ThemeManifest>);

#[derive(Serialize, Deserialize)]
struct ThemeTuple {
    manifests: ThemeManifests,
    repo: Repository,
}

#[derive(Serialize, Deserialize)]
struct ThemeOutput {
    name: String,
    source: FetchURL,
    usercss: String,
    schemes: String,
    include: Vec<ExtOutput>,
}

// Snippets

#[derive(Serialize, Deserialize)]
struct Snippet {
    code: String,
    preview: String,
}

#[derive(Serialize, Deserialize)]
struct Output {
    //extensions: HashMap<String, ExtOutput>,
    //apps: HashMap<String, AppOutput>,
    //themes: HashMap<String, ThemeOutput>,
    snippets: HashMap<String, String>,
}

fn sanitize_name(name: &str) -> String {
    name.to_case(Case::Camel)
        .replace(|c| !char::is_alphanumeric(c), "")
}

async fn search_tag(crab: &Octocrab, tag: &str) -> Vec<Repository> {
    let mut current_page = crab
        .search()
        .repositories(&format!("topic:{tag}"))
        .sort("stars")
        .order("desc")
        .per_page(100)
        .send()
        .await
        .expect("Failed to search repositories");

    let mut all_pages: Vec<Repository> = current_page.take_items();

    while let Ok(Some(mut new_page)) = crab.get_page(&current_page.next).await {
        all_pages.extend(new_page.take_items());

        current_page = new_page;
    }

    all_pages
}

fn filter_tag(blacklist: &[String], tag: Vec<Repository>) -> Vec<Repository> {
    tag.into_iter()
        .filter(|x| {
            !blacklist.contains(
                &x.html_url
                    .clone()
                    .expect("Epic html_url failure")
                    .to_string(),
            ) && !x.archived.unwrap_or(false)
        })
        .collect()
}

async fn get_manifest(crab: &Octocrab, repo: &Repository) -> Option<String> {
    match crab
        .repos(repo.owner.clone().unwrap().login, repo.clone().name)
        .get_content()
        .path("manifest.json")
        .send()
        .await
    {
        Ok(ok) => {
            return match ok.items.first() {
                Some(some) => return some.decoded_content(),
                None => {
                    println!(
                        "Failed to convert manifest.json to string from: {}",
                        repo.html_url.clone().expect("Epic html_url failure")
                    );
                    None
                }
            }
        }
        Err(..) => {
            println!(
                "Failed to get manifest.json from: {}",
                repo.html_url.clone().expect("Epic html_url failure")
            );
            None
        }
    }
}

fn get_owner(repo: &Repository) -> String {
    repo.owner.clone().expect("failed to get repo owner?").login
}

fn get_default_branch(repo: &Repository) -> String {
    repo.default_branch
        .clone()
        .expect("failed to get default_branch")
}

async fn get_rev(crab: &Octocrab, owner: &str, name: &str, branch: &String) -> Option<String> {
    match crab.commits(owner, name).get(branch.clone()).await {
        Ok(x) => Some(x.sha),
        Err(..) => {
            println!(
                "Failed to get latest commit of github.com/{}/{} branch: {}",
                owner, name, branch
            );
            None
        }
    }
}

fn fetch_url(url: String) -> FetchURL {
    println!("Hashing: {}", url);
    let command_stdout = Command::new("nix")
        .args(["store", "prefetch-file", &url, "--json"])
        .output()
        .expect("failed to run nix store prefetch-file lol")
        .stdout;
    let prefetched: Prefetch = serde_json::from_str(&String::from_utf8_lossy(&command_stdout))
        .expect("failed to parse nix store prefetch-file output, how did you make this fail?");

    FetchURL {
        url: url.clone(),
        hash: prefetched.hash,
    }
}

fn fetch_gh_archive(repo: &Repository, rev: String) -> FetchURL {
    let url = format!(
        "{}/archive/{}.tar.gz",
        repo.html_url.clone().expect("Epic html_url failure"),
        rev
    );
    println!("Hashing: {}", url);
    let command_stdout = Command::new("nix")
        .args(["store", "prefetch-file", &url, "--unpack", "--json"])
        .output()
        .expect("failed to run nix store prefetch-file lol")
        .stdout;
    let prefetched: Prefetch = serde_json::from_str(&String::from_utf8_lossy(&command_stdout))
        .expect("failed to parse nix store prefetch-file output, how did you make this fail?");
    FetchURL {
        url: url.clone(),
        hash: prefetched.hash,
    }
}

async fn extensions(crab: &Octocrab, blacklist: &[String]) -> HashMap<String, ExtOutput> {
    let mut potato: HashMap<String, FetchURL> = HashMap::new();
    let extensions: Vec<Repository> =
        filter_tag(blacklist, search_tag(crab, "spicetify-extensions").await);

    let mut ext_tuple: Vec<ExtTuple> = vec![];

    for i in 0..extensions.len() {
        let manifest = match get_manifest(crab, &extensions[i]).await {
            Some(x) => x,
            None => continue,
        };

        let parse: ExtManifests = match serde_json::from_str(&manifest) {
            Ok(ok) => ok,
            Err(..) => {
                println!(
                    "Failed to parse manifest from: {}",
                    &extensions[i].html_url.clone().unwrap().to_string()
                );

                continue;
            }
        };

        ext_tuple.push(ExtTuple {
            manifests: parse,
            repo: extensions[i].clone(),
        });
    }
    let mut ext_outputs: HashMap<String, ExtOutput> = HashMap::new();
    for i in ext_tuple {
        let owner = &get_owner(&i.repo);
        let name = &i.repo.name;

        for j in i.manifests.0 {
            let branch = j.branch.unwrap_or(get_default_branch(&i.repo));

            let rev = match get_rev(crab, owner, name, &branch).await {
                Some(x) => x,
                None => continue,
            };

            let key = format!("{}-{}-{}", owner, name, branch);

            if !potato.contains_key(&key) {
                potato.insert(key.clone(), fetch_gh_archive(&i.repo, rev));
            };

            ext_outputs.insert(
                sanitize_name(&j.name),
                ExtOutput {
                    name: j.main.split('/').last().unwrap().to_string(),
                    source: potato.get(&key).unwrap().clone(),
                    main: j.main,
                },
            );
        }
    }

    ext_outputs
}

async fn apps(crab: &Octocrab, blacklist: &[String]) -> HashMap<String, AppOutput> {
    let mut potato: HashMap<String, FetchURL> = HashMap::new();
    let apps: Vec<Repository> = filter_tag(blacklist, search_tag(crab, "spicetify-apps").await);

    let mut app_tuple: Vec<AppTuple> = vec![];
    for i in 0..apps.len() {
        let manifest = match get_manifest(crab, &apps[i]).await {
            Some(x) => x,
            None => continue,
        };

        let parse: AppManifests = match serde_json::from_str(&manifest) {
            Ok(ok) => ok,
            Err(..) => {
                println!(
                    "Failed to parse manifest from: {}",
                    &apps[i].html_url.clone().unwrap().to_string()
                );

                continue;
            }
        };

        app_tuple.push(AppTuple {
            manifests: parse,
            repo: apps[i].clone(),
        });
    }

    let mut app_outputs: HashMap<String, AppOutput> = HashMap::new();

    for i in app_tuple {
        let owner = &get_owner(&i.repo);
        let name = &i.repo.name;

        for j in i.manifests.0 {
            let branch = j.branch.unwrap_or(get_default_branch(&i.repo));

            let rev = match get_rev(crab, owner, name, &branch).await {
                Some(x) => x,
                None => continue,
            };

            let key = format!("{}-{}-{}", owner, name, branch);

            if !potato.contains_key(&key) {
                potato.insert(key.clone(), fetch_gh_archive(&i.repo, rev));
            };

            app_outputs.insert(
                sanitize_name(&j.name),
                AppOutput {
                    name: j.name,
                    source: potato.get(&key).unwrap().clone(),
                },
            );
        }
    }

    app_outputs
}

async fn themes(crab: &Octocrab, blacklist: &[String]) -> HashMap<String, ThemeOutput> {
    let mut potato: HashMap<String, FetchURL> = HashMap::new();
    let themes: Vec<Repository> = filter_tag(blacklist, search_tag(crab, "spicetify-themes").await);

    let mut theme_tuple: Vec<ThemeTuple> = vec![];
    for i in 0..themes.len() {
        let manifest = match get_manifest(crab, &themes[i]).await {
            Some(x) => x,
            None => continue,
        };

        let parse: ThemeManifests = match serde_json::from_str(&manifest) {
            Ok(ok) => ok,
            Err(..) => {
                println!(
                    "Failed to parse manifest from: {}",
                    &themes[i].html_url.clone().unwrap().to_string()
                );

                continue;
            }
        };

        theme_tuple.push(ThemeTuple {
            manifests: parse,
            repo: themes[i].clone(),
        });
    }

    let mut theme_outputs: HashMap<String, ThemeOutput> = HashMap::new();

    for i in theme_tuple {
        let owner = &get_owner(&i.repo);
        let name = &i.repo.name;

        for j in i.manifests.0 {
            let branch = j.branch.unwrap_or(get_default_branch(&i.repo));

            let rev = match get_rev(crab, owner, name, &branch).await {
                Some(x) => x,
                None => continue,
            };

            let key = format!("{}-{}-{}", owner, name, branch);

            if !potato.contains_key(&key) {
                potato.insert(key.clone(), fetch_gh_archive(&i.repo, rev));
            };

            theme_outputs.insert(
                sanitize_name(&j.name),
                ThemeOutput {
                    name: j.name.clone(),
                    source: potato.get(&key).unwrap().clone(),
                    schemes: j.schemes,
                    usercss: j.usercss,
                    include: match j.include {
                        None => vec![],
                        Some(x) => {
                            let mut val: Vec<ExtOutput> = vec![];
                            for s in x {
                                if s.starts_with("http") {
                                    val.push(ExtOutput {
                                        name: s.split('/').last().unwrap().to_string(),
                                        main: "__INCLUDE__".to_string(),
                                        source: fetch_url(s),
                                    })
                                } else {
                                    val.push(ExtOutput {
                                        name: s.split('/').last().unwrap().to_string(),
                                        main: s.clone(),
                                        source: potato.get(&key).unwrap().clone(),
                                    })
                                }
                            }
                            val
                        }
                    },
                },
            );
        }
    }

    theme_outputs
}

#[tokio::main]
async fn main() {
    let crab: Octocrab = octocrab::Octocrab::builder()
        .personal_token(std::env::var("GITHUB_TOKEN").expect("no PAT key moron"))
        .build()
        .expect("Failed to crab");

    let blacklist = crab
        .repos("spicetify", "marketplace")
        .get_content()
        .path("resources/blacklist.json")
        .r#ref("main")
        .send()
        .await
        .expect("Could not get blacklist.json")
        .items
        .first()
        .unwrap()
        .decoded_content();

    let vector: Blacklist = serde_json::from_str(&blacklist.expect("Failed to read blacklist"))
        .expect("Failed to parse blacklist");
    let snippets_json = crab
        .repos("spicetify", "marketplace")
        .get_content()
        .path("resources/snippets.json")
        .r#ref("main")
        .send()
        .await
        .expect("Could not get snippets.json")
        .items
        .first()
        .unwrap()
        .decoded_content();
    let snippets_vec: Vec<Snippet> =
        serde_json::from_str(&snippets_json.expect("Failed to read snippets.json"))
            .expect("Failed to parse snippets.json");

    let mut snippets_output: HashMap<String, String> = HashMap::new();

    for i in snippets_vec {
        // i hate strings
        let name = Path::new(&i.preview)
            .file_stem()
            .unwrap()
            .to_os_string()
            .into_string()
            .unwrap();
        snippets_output.insert(sanitize_name(&name), i.code);
    }

    //let extensions = extensions(&crab, &vector.repos);
    //let apps = apps(&crab, &vector.repos);
    //let themes = themes(&crab, &vector.repos);
    // Theme stuff
    //let output = join!(extensions, apps, themes);

    let final_output: Output = Output {
        //extensions: output.0,
        //apps: output.1,
        //themes: output.2,
        snippets: snippets_output,
    };

    let output = File::create("generated.json").expect("can't create generated.json");
    serde_json::to_writer(&output, &final_output).expect("failed to save generated.json");
}
