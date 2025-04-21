import json
import subprocess

def get_hash(owner, repo, branch, revision):
    # Construct the URL for the tar.gz file
    url = f"https://github.com/{owner}/{repo}/archive/{revision}.tar.gz"

    # Construct the command to run
    command = f"nix-shell --pure -p nix cacert --run 'nix-hash --type sha256 --to-base32 $(nix-prefetch-url --unpack {url} | tail -n 1)'"

    # Execute the command and capture the output
    try:
        result = subprocess.check_output(command, shell=True, text=True).strip()
        return result
    except subprocess.CalledProcessError as e:
        print(f"Error executing command for {owner}/{repo}: {e}")
        return None

def generate_repository_data(owner, repo, branch, revision, suffix):
    return {
        "type": "Git",
        "repository": {
            "type": "GitHub",
            "owner": owner,
            "repo": repo
        },
        "branch": branch,
        "revision": revision,
        "url": f"https://github.com/{owner}/{repo}/archive/{revision}.tar.gz",
        "hash": get_hash(owner, repo, branch, revision)
    }

# List of repositories ("owner", "repo", "branch", "revision", "suffix (for multiple repos with same owner)"),
repositories = [
    ("AroLucy", "Pocket", "main", "a5c3b2a2e781a86404c19a996a1048e782c08450", "_1"),
    ("AroLucy", "Spicetify-Sidebar-Controls", "main", "8299a69e7319e0d6ced450458d2b7be5c2462adc", "_2"),
    ("Astromations", "Hazy", "main", "413748dd7048857f5b4a1c013e945c10818e1169", ""),
    ("bluedrift", "Spicetify-Throwback", "master", "4eade188f2e16f937596f0d5f4532bec707521ee", ""),
    ("canbeardig", "Spicetify-Orchis-Colours-v2", "main", "5bf3fcf0696514dcf3e95f4ae3fd00261ccc5dcc", ""),
    ("catppuccin", "spicetify", "main", "4294a61f54a044768c6e9db20e83c5b74da71091", ""),
    ("Comfy-Themes", "Spicetify", "main", "2c22f3649a82e599be0e7eb506a0f83459caf9e8", ""),
    ("Droidiar", "simpleoutline-spicetify", "main", "0d1a08d03d8dc9be4ac0f71a16e4c5ed61f6a295", ""),
    ("getomni", "spicetify", "main", "253ae45d2cac2dc3d92a43193ea8f6d9e7e1d3aa", ""),
    ("harbassan", "spicetify-galaxy", "main", "2b2e33c02c5adffd6737e4a93c261e961fad8eca", "-themes"),
    ("JayTheXXVII", "RevertX2", "main", "d394c5761e62bef30b6132b9324d2856315e0cb1", ""),
    ("JulienMaille", "spicetify-dynamic-theme", "main", "a49a029bed4d58cadd1dddb586ff06a200c0233e", "_1"),
    ("JulienMaille", "dribbblish-dynamic-theme", "main", "27f4fd3a263075dd36d617a28cf68011012f53ec", "_2"),
    ("Kennubyte", "pinkers", "main", "2adcb1ba580d2ebe9a48508ab0b866689de44987", ""),
    ("LimeAndPyro", "Grayscale-Spotify-Theme", "main", "54c001177477b89e411a15fa6caf02e3aed0d8ca", ""),
    ("luximus-hunter", "accented", "master", "b6c329109c76ca20a9d878cdf8218a32c4653a89", ""),
    ("Motschen", "Retroblur", "fresh", "685cf3aea4ed1a4d82f687293f0efb5baa1aec06", ""),
    ("MrBiscuit921", "spicetify-themes", "master", "ccc1fd15c34b9ffa206d19aa83afadf7235f3296", ""),
    ("nimsandu", "spicetify-bloom", "main", "809c042ca8f88540604fbd6aca35f42bddfcaf27", ""),
    ("pjaspinski", "spicetify-themes", "master", "7e9e898124c96f115dc61fb91d0499ae81f56892", ""),
    ("Rubutter", "notRetroblur", "main", "a86f646ba3052c750300dba64901db3f3fd2bfce", ""),
    ("sanoojes", "Spicetify-colorful", "main", "09396aaa0b0ba1ec93bcc95f5c820ca7914d1d50", "-themes_1"),
    ("sanoojes", "Spicetify-Lucid", "main", "bf6b1589374dd8c31acbd8749a59e7c935157656", "-themes_2"),
    ("sanoojes", "Spicetify-ShadeX", "main", "9b8fe4b5e7f1298167b278310111c0757d86d127", "-themes_3"),
    ("Spicetify", "spicetify-themes", "master", "a9ce22b3d3df303d994974b746c839c7d0907101", "-themes"),
    ("SyndiShanX", "Spotify-Dark", "main", "b153f4f0f28724b659ebe6da9deae115169762c2", "-themes"),
    ("thefoodiee", "blackout", "main", "e913ecc56b2415566d485d951a7c1d2606aa8c1d", ""),
    ("williamckha", "spicetify-fluent", "master", "64b946af1ee4a5ed761d2f065c45b710e06bc123", ""),
    #("owner", "repo", "branch", "revision", "suffix (for multiple repos with same owner)"),
]

# Create the data structure
data = {
    "pins": {f"{owner}{suffix}": generate_repository_data(owner, repo, branch, revision, suffix) for owner, repo, branch, revision, suffix in repositories},
    "version": 5
}

# Specify the file name
file_name = 'theSources.json'

# Write the JSON data to a file
with open(file_name, 'w') as json_file:
    json.dump(data, json_file, indent=2)

print(f"JSON data has been written to {file_name}")
