use convert_case::{Case, Casing};
use futures::StreamExt as _;
use octocrab::{
    models::{repos::Content, Repository},
    Octocrab,
};
use serde::{de::DeserializeOwned, Deserialize, Serialize};
use serde_with::{serde_as, OneOrMany};
use std::{
    collections::{HashMap, HashSet},
    fs::File,
    process::Command,
};

const FETCH_CONCURRENCY: usize = 8;

#[derive(Deserialize)]
struct Blacklist {
    repos: Vec<String>,
}

#[derive(Deserialize)]
struct Prefetch {
    hash: String,
}

#[derive(Serialize, Deserialize, Clone)]
struct FetchURL {
    url: String,
    hash: String,
}

impl FetchURL {
    fn from_repo(repo: &Repository, rev: &str) -> Self {
        let url = format!(
            "{}/archive/{rev}.tar.gz",
            repo.html_url.as_ref().expect("Epic html_url failure"),
        );

        println!("Hashing: {url}");
        let command_stdout = Command::new("nix")
            .args(["store", "prefetch-file", &url, "--unpack", "--json"])
            .output()
            .expect("failed to run nix store prefetch-file lol")
            .stdout;

        let prefetched: Prefetch = serde_json::from_str(&String::from_utf8_lossy(&command_stdout))
            .expect("failed to parse nix store prefetch-file output, how did you make this fail?");

        FetchURL {
            url,
            hash: prefetched.hash,
        }
    }

    fn from_url(url: &str) -> Self {
        println!("Hashing: {url}");
        let command_stdout = Command::new("nix")
            .args(["store", "prefetch-file", url, "--unpack", "--json"])
            .output()
            .expect("failed to run nix store prefetch-file lol")
            .stdout;

        let prefetched: Prefetch = serde_json::from_str(&String::from_utf8_lossy(&command_stdout))
            .expect("failed to parse nix store prefetch-file output, how did you make this fail?");
        FetchURL {
            url: url.to_string(),
            hash: prefetched.hash,
        }
    }
}

trait Manifest {
    const TAG: &'static str;

    type Output;

    fn name(&self) -> &str;
    fn branch(&self) -> Option<&str>;
    fn into_output(self, source: FetchURL) -> Self::Output;
}

#[serde_as]
#[derive(Clone, Deserialize, Debug)]
struct Manifests<T: DeserializeOwned>(#[serde_as(as = "OneOrMany<_>")] Vec<T>);

/// A tuple of a manifest and its corresponding repository.
struct ManifestTuple<T: DeserializeOwned> {
    manifests: Manifests<T>,
    repo: Repository,
}

// Extension
#[derive(Clone, Debug, Deserialize)]
struct ExtManifest {
    name: String,
    main: String,
    branch: Option<String>,
}

impl Manifest for ExtManifest {
    const TAG: &'static str = "spicetify-extensions";

    type Output = ExtOutput;

    fn name(&self) -> &str {
        &self.name
    }

    fn branch(&self) -> Option<&str> {
        self.branch.as_deref()
    }

    fn into_output(self, source: FetchURL) -> Self::Output {
        ExtOutput {
            name: self.main.split('/').next_back().unwrap().to_string(),
            source,
            main: self.main,
        }
    }
}

#[derive(Serialize, Deserialize)]
struct ExtOutput {
    name: String,
    main: String,
    source: FetchURL,
}

// App
#[derive(Clone, Debug, Deserialize)]
struct AppManifest {
    name: String,
    branch: Option<String>,
}

impl Manifest for AppManifest {
    const TAG: &'static str = "spicetify-apps";

    type Output = AppOutput;

    fn name(&self) -> &str {
        &self.name
    }

    fn branch(&self) -> Option<&str> {
        self.branch.as_deref()
    }

    fn into_output(self, source: FetchURL) -> Self::Output {
        AppOutput {
            name: self.name,
            source,
        }
    }
}

#[derive(Serialize, Deserialize)]
struct AppOutput {
    name: String,
    source: FetchURL,
}

// Theme
#[derive(Clone, Debug, Deserialize)]
struct ThemeManifest {
    name: String,
    usercss: String,
    schemes: String,
    include: Option<Vec<String>>,
    branch: Option<String>,
}

impl Manifest for ThemeManifest {
    const TAG: &'static str = "spicetify-themes";

    type Output = ThemeOutput;

    fn name(&self) -> &str {
        &self.name
    }

    fn branch(&self) -> Option<&str> {
        self.branch.as_deref()
    }

    fn into_output(self, source: FetchURL) -> Self::Output {
        let include = self
            .include
            .unwrap_or_default()
            .into_iter()
            .map(|s| {
                if s.starts_with("http") {
                    ExtOutput {
                        name: s.split('/').next_back().unwrap().to_string(),
                        main: "__INCLUDE__".to_string(),
                        source: FetchURL::from_url(&s),
                    }
                } else {
                    ExtOutput {
                        name: s.split('/').next_back().unwrap().to_string(),
                        main: s,
                        source: source.clone(),
                    }
                }
            })
            .collect::<Vec<ExtOutput>>();

        ThemeOutput {
            name: self.name,
            source,
            schemes: self.schemes,
            usercss: self.usercss,
            include,
        }
    }
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

impl Snippet {
    /// Returns the name of the snippet, derived from the preview file name.
    fn name(&self) -> String {
        self.preview
            .rsplit('/')
            .next()
            .unwrap_or(&self.preview)
            .rsplit('.')
            .skip(1)
            .collect()
    }
}

#[derive(Serialize, Deserialize)]
struct Output {
    // extensions: HashMap<String, ExtOutput>,
    // apps: HashMap<String, AppOutput>,
    // themes: HashMap<String, ThemeOutput>,
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

fn get_owner(repo: &Repository) -> String {
    repo.owner
        .as_ref()
        .map(|o| o.login.clone())
        .expect("failed to get repo owner?")
}

fn get_default_branch(repo: &Repository) -> String {
    repo.default_branch
        .as_ref()
        .expect("failed to get default_branch")
        .to_owned()
}

async fn get_rev(crab: &Octocrab, owner: &str, name: &str, branch: &str) -> Option<String> {
    let Ok(commit) = crab.commits(owner, name).get(branch).await else {
        println!("Failed to get latest commit of github.com/{owner}/{name} branch: {branch}");
        return None;
    };

    Some(commit.sha)
}

async fn get_manifest(crab: &Octocrab, repo: &Repository) -> Option<String> {
    let items = crab
        .repos(repo.owner.as_ref().map(|o| &o.login).unwrap(), &repo.name)
        .get_content()
        .path("manifest.json")
        .send()
        .await
        .inspect_err(|_| {
            println!(
                "Failed to get manifest.json from: {}",
                repo.html_url.as_ref().expect("Epic html_url failure")
            );
        })
        .ok()?;

    if items.items.is_empty() {
        println!(
            "Failed to get manifest.json from: {}",
            repo.html_url.as_ref().expect("Epic html_url failure")
        );
        return None;
    }

    items.items.first().and_then(Content::decoded_content)
}

async fn fetch_tuples<T>(
    crab: &Octocrab,
    repos: impl IntoIterator<Item = Repository>,
) -> impl Iterator<Item = ManifestTuple<T>>
where
    T: DeserializeOwned,
{
    // fetch up to `FETCH_CONCURRENCY` manifests concurrently
    futures::stream::iter(repos.into_iter().map(|repo| async move {
        let manifest_json = get_manifest(crab, &repo).await?;

        let Ok(manifests) = serde_json::from_str::<Manifests<T>>(&manifest_json) else {
            println!(
                "Failed to parse manifest from: {}",
                repo.html_url.as_ref().expect("Epic html_url failure")
            );
            return None;
        };

        Some(ManifestTuple::<T> { manifests, repo })
    }))
    .buffer_unordered(FETCH_CONCURRENCY)
    .collect::<Vec<_>>()
    .await
    .into_iter()
    .flatten()
}

async fn collect_outputs<M>(
    crab: &Octocrab,
    blacklist: &HashSet<String>,
) -> HashMap<String, M::Output>
where
    M: Manifest + DeserializeOwned,
{
    let repos = search_tag(crab, M::TAG).await.into_iter().filter(|repo| {
        !blacklist.contains(
            &repo
                .html_url
                .as_ref()
                .expect("Epic html_url failure")
                .to_string(),
        ) && !repo.archived.unwrap_or(false)
    });

    let tuples = fetch_tuples::<M>(crab, repos).await;

    let mut prefetch_cache: HashMap<String, FetchURL> = HashMap::new();
    let mut outputs = HashMap::new();

    for tuple in tuples {
        let owner = get_owner(&tuple.repo);
        let name = &tuple.repo.name;

        for manifest in tuple.manifests.0 {
            let branch = manifest
                .branch()
                .map(ToOwned::to_owned)
                .unwrap_or_else(|| get_default_branch(&tuple.repo));

            let Some(rev) = get_rev(crab, &owner, name, &branch).await else {
                continue;
            };

            let key = format!("{owner}-{name}-{branch}");
            let source = prefetch_cache
                .entry(key)
                .or_insert_with(|| FetchURL::from_repo(&tuple.repo, &rev))
                .clone();

            let output_name = sanitize_name(manifest.name());
            outputs.insert(output_name, manifest.into_output(source));
        }
    }

    outputs
}

#[tokio::main]
async fn main() {
    let crab = Octocrab::builder()
        .personal_token(std::env::var("GITHUB_TOKEN").expect("no PAT key moron"))
        .build()
        .expect("Failed to crab");

    let blacklist_json = crab
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
        .decoded_content()
        .expect("Failed to read blacklist");

    let _blacklist: HashSet<String> = HashSet::from_iter(
        serde_json::from_str::<Blacklist>(&blacklist_json)
            .expect("Failed to parse blacklist")
            .repos,
    );

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
        .decoded_content()
        .expect("Failed to read snippets.json");

    let snippets_vec: Vec<Snippet> =
        serde_json::from_str(&snippets_json).expect("Failed to parse snippets.json");

    let snippets_output: HashMap<String, String> = snippets_vec
        .into_iter()
        .map(|i| {
            let name = i.name();
            (sanitize_name(&name), i.code)
        })
        .collect();

    // let extensions = collect_outputs::<ExtManifest>(&crab, &_blacklist);
    // let apps = collect_outputs::<AppManifest>(&crab, &_blacklist);
    // let themes = collect_outputs::<ThemeManifest>(&crab, &_blacklist);
    // Theme stuff
    // let output = join!(extensions, apps, themes);

    let final_output = Output {
        // extensions: output.0,
        // apps: output.1,
        // themes: output.2,
        snippets: snippets_output,
    };

    let output = File::create("generated.json").expect("can't create generated.json");
    serde_json::to_writer(&output, &final_output).expect("failed to save generated.json");
}
