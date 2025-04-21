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
        print(f"Error executing commandfor {owner}/{repo}: {e}")
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
    ("bc9123", "spicetify-history", "main", "fe31a1554bcc2cc938cf9ac3d2712a1611dbdadc", "-apps"),
    ("Bergbok", "Spicetify-Creations", "dist/history-in-sidebar", "621965fb5f8d142313eb11d95897e891907c5803", "-apps_1"),
    ("Bergbok", "Spicetify-Creations", "dist/playlist-tags", "299128c77efcfd29666d2593d7760d5a99ef6341", "-apps_2"),
    ("ECE49595-Team-6", "EnhancifyInstall", "main", "5d40a98a378a778b6be5f8b68eb60a6884ba43b0", ""),
    ("harbassan", "spicetify-apps", "dist", "0a82d88e5517f21595c641c60015671dacb1d7fe", "-apps"),
    ("jeroentvb", "spicetify-combined-playlists", "dist", "44c8d54619601a731fb2b6692cb8c5ed2289b50d", "-apps"),
    ("Konsl", "spicetify-visualizer", "dist", "ff3a0914c92ecfc02b7c0279ad832630c66e869f", "-apps"),
    ("ossd-s24", "spicetify-study-banger-app", "main", "11034e6bc08fd55c188dfef518f15e61c1e1dece", ""),
    ("Sowgro", "betterLibrary", "main", "c8438030837ce904cf8dc5308cfae15dc793aebd", ""),
    ("Spicetify", "cli", "main", "465f6e36d02d3b142a871856b3ab7236fa31c263", "-cli"),
    ("Spicetify", "spicetify-marketplace", "dist", "e431eaaf789bac9e59d439e3ee68b09a580eb444", "-marketplace"),
    ("theRealPadster", "name-that-tune", "dist", "858b98baa97e486a8589b26164c9eb1aa3605282", "-apps"),
    #("owner", "repo", "branch", "revision", "suffix (for multiple repos with same owner)"),
]

# Create the data structure
data = {
    "pins": {f"{owner}{suffix}": generate_repository_data(owner, repo, branch, revision, suffix) for owner, repo, branch, revision, suffix in repositories},
    "version": 5
}

# Specify the file name
file_name = 'appSources.json'

# Write the JSON data to a file
with open(file_name, 'w') as json_file:
    json.dump(data, json_file, indent=2)

print(f"JSON data has been written to {file_name}")
