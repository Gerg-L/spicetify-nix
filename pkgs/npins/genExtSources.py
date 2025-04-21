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
    ("39digits", "spicetify-never-autoplay", "main", "cffd70c34642789e4240fe361716fb3530770e07", ""),
    ("41pha1", "spicetify-extensions", "main", "5015b9122a9c39274bdc7507e1de4fec0cc20f95", ""),
    ("adufr", "spicetify-extensions", "main", "4af311ecf572cd112f3b954c1d1446eebbda0180", ""),
    ("adventuretc", "Spicetify-HideImages-Extension", "main", "e32e58d1260fe541863f987ed5ce7c89fea34480", ""),
    ("afonsojramos", "spotify-details-extractor", "main", "fde99f8e6c6b57551e8242c3e4a34f54c150001e", ""),
    ("Afterlifepro", "lilplayer", "main", "91da974e79200cc2c8368a0f84c3a0d38070bf88", ""),
    ("Aimarekin", "Aimarekins-Spicetify-Extensions", "main", "82dbbaec37540e82dcd11d897646c0fdb068c3e8", ""),
    ("Akasiek", "spicetify-lucky-lp", "main", "c3eed245b34bd3c80004acc1b61f5615aaaa3d5c", ""),
    ("AkselVdev", "AkselV-Spicetify", "main", "fdafd16eed678bff56015f99306cb09b9948f1a6", ""),
    ("aloverso", "spotify-friendlikes", "main", "e628837851e6c6a1e1e83c9dfd6bea509bd85d30", ""),
    ("Alpacinator", "Collapsing-Library", "main", "a0ba8654829c98862fc632109b2e95061f711e66", ""),
    ("amanharwara", "spicetify-autoVolume", "master", "d7f7962724b567a8409ef2898602f2c57abddf5a", ""),
    ("andrsdt", "spicetify-show-queue-duration", "main", "5559c50559826f8a1cd3bb45abb8e6022f88fe4c", ""),
    ("api-haus", "spicetify-antisocial", "main", "839b87737df5e0af6a61df16e27358a564754355", ""),
    ("ashercs", "SpicetifyAOTYScores", "main", "a5f480a6eb7fe5a375254ff87fe09277cb0f2d1e", ""),
    ("Aspecky", "spicetify-extensions", "main", "c7f1f5060dfb4ab9cef00c07ef305b2ae3938f9e", ""),
    ("Aztup", "EnhancePlus", "master", "7edf22b8cf45d07384b7d05ffda6c9dc1b7c20e0", ""),
    ("bc9123", "spicetify-convenient-repeat-extension", "main", "8101a4dc5e039b5cb06b23ba4065e78783faf8b9", "-extensions"),
    ("BenWithJamInn", "spotify-track-trim", "main", "ed6f0fbf2ab8a7b5589df34f9ef8d019b0162e61", ""),
    ("Bergbok", "Spicetify-Creations", "dist/auto-skip-tracks-by-duration", "3406563d01f894397bdbea96de0100ad4730b1b4", "-extensions"),
    ("BitesizedLion", "AnonymizedRadios", "master", "1741f9ba19fe5e20183b3e65210ed6dec3bac17d", ""),
    ("BlafKing", "spicetify-cat-jam-synced", "main", "e7bfd49fcc13457bbc98e696294cf5cf43eb6c31", ""),
    ("bleizix", "part-selector", "main", "de5ec949d3b75be9ebba99803e52ee7f68241fba", ""),
    ("bojanraic", "spicetify-extensions", "main", "09d1a57d4978cf65073c9be2e39b3fe1823ed1c1", ""),
    ("brimell", "spicetify-star-ratings", "main", "79eea09607b56d37cfb815f4226856b1bf6dcebe", ""),
    ("cAttte", "spicetify-extensions", "main", "7652326e65abbbe853800d018f2d4885b71088ca", ""),
    ("ch4xm", "spicetify-song-views", "main", "afc3e1863625ac14d3a68588ea8bedd594ca4b7f", ""),
    ("daksh2k", "Spicetify-stuff", "master", "e9f2dbe020f612b3cb7746620ad702e4f4a3c24f", ""),
    ("darkthemer", "spicetify-extensions", "main", "905e82e9c2b88a93dcad59dde7f51d5e2ee77c30", ""),
    ("DarkWolfie-YouTube", "requestplus", "main", "f8212955c906661c6f4fa8d92ec70c1f7508d84f", ""),
    ("Dotsgo", "spicetify-randomish-playlist-maker", "main", "96107a7ab442025e36c305c97aa04ac18e1ccbc0", "_1"),
    ("Dotsgo", "spicetify-playlist-from-recently-played-tracks", "main", "2661846c17fb10fb862e3166be29ef821564112f", "_2"),
    ("Dotsgo", "spicetify-remove-recently-played-tracks", "main", "0c3d4811e94797b68643898e54a268172a955b2a", "_3"),
    ("duffey", "spicetify-furigana-lyrics", "master", "14a15706a84467b43af114d3a1a4177428bc8900", ""),
    ("dupitydumb", "CustomLyrics-Spotify", "main", "04475b44ecdb2554119d923e1dc906e6c13f6ab0", ""),
    ("Eeu2005", "Playbar-Dynamic", "main", "d6086d6f4a4e276d4bf69e45b218176342dbd5e9", ""),
    ("fl3xm3ist3r", "spicetifyExtensions", "master", "1ca067c543938a88d831a308c8a5afa86efbd2c1", ""),
    ("FlafyDev", "spotify-css-editor", "main", "0e1bbc72f3bdf81cfcdecd28e735e0989ac56b96", "_1"),
    ("FlafyDev", "spotify-listen-together", "main", "7e657d1be5001da4439b560c0775039812e4abba", "_2"),
    ("GentlyTech", "spicetify-extensions", "master", "c3638366aa7497a1b4390f8bc0314813c2e69ad4", ""),
    ("GiorgosAthanasopoulos", "Skip-or-Play-Liked-Songs", "master", "aa6d6e8271990d617f2e58b329c0cd0aaff51d31", ""),
    ("gray-matter", "spicetify-hot-cues", "main", "a82a4d7694ab7cc742969babeb7a10f4b3ffaa13", ""),
    ("HackedApp", "spicetify-vinyl-overlay", "main", "2a4ee76cb64645603724f4d446cb12a4932794b4", ""),
    ("hideki0403", "spicetify-share-on-twitter", "master", "7ccb465143f2205d6b0e51969327fd4f8c842ee0", ""),
    ("hoeci", "sort-play", "main", "56c8310b53b416083fdc6214e90d0da3ea420954", ""),
    ("huhridge", "huh-spicetify-extensions", "main", "d58201e27716df86ace457a82dce980175c2d65d", ""),
    ("iHelops", "smooth-scrolling", "main", "10b1aebdbfbb9c7cc04c8b33e074f653437a0dd0", ""),
    ("Isbo2000", "spicetify-collapse-sidebar", "main", "02dc5cb71c18d6af2b03d1f040868f27728913d0", ""),
    ("jeroentvb", "spicetify-playlist-icons", "main", "a0cdaac6d9f4982538920825b7c3693c87e9bbdf", "-extensions_1"),
    ("jeroentvb", "spicetify-power-bar", "main", "2eb4af897e52c17baf05f4d60bf4a8bb5bf3d370", "-extensions_2"),
    ("jeroentvb", "spicetify-genre", "master", "9cd089e46b95fde0f0d85ef738f21cde831a9d8e", "-extensions_3"),
    ("jeroentvb", "spicetify-volume-percentage", "main", "8ed5065e4db31e7391aacbb2409f3cdcce6de6ba", "-extensions_4"),
    ("Kamiloo13", "spicetify-extensions", "main", "f97236d7cdcef4478ebb57a1332258bda0aaab27", ""),
    ("kevin-256", "Spicetify-color-over-Web-Socket", "main", "f7133920602dff0aab62b6480e938ec726c70a41", ""),
    ("Konsl", "spicetify-extensions", "main", "636c6bdf82e80e762e1828c47dd9cbed2ced4263", "-extensions"),
    ("kyrie25", "Spicetify-Cache-Cleaner", "main", "8d0ec54581920629734acc5e4449d34d6afce7fb", "_1"),
    ("kyrie25", "spicetify-oneko", "main", "589a8cc3a3939b8c9fc4f2bd087ed433e9af5002", "_2"),
    ("kyrie25", "spicetify-utilities", "main", "af53aabc63b8d197b952f4ecb0e4252ee79eca26", "_3"),
    ("L3-N0X", "spicetify-dj-info", "main", "b55c9b8c8b00100b42e562829c77d012191f0c07", ""),
    ("lightningik", "spicetify-extensions", "main", "5e0bf19e21d8ea14a48b05adcd36a476e236e638", ""),
    ("LucasOe", "spicetify-genres", "main", "38db860f7997edc2ee1c40445938e6c824e92c1c", ""),
    ("Marcell-Puskas", "Spicetify-Toggle-Autoplay", "main", "fd5dc0b712092e7d03c8166f948cf5570b2a0170", ""),
    ("Maskowh", "spicetify-old-like-button-extension", "main", "af409119cfc222540aa4467d8024c4c7b6977eef", ""),
    ("mchubby", "spicetify-copy-track-titles", "main", "9380eafa83fba89707ac9aea9707eb755833fcc5", ""),
    ("Midra429", "spicetify-share-on-misskey", "main", "3227ca58a7c6a7ca106808b61c6bad6b523e327b", ""),
    ("MLGRussianXP", "spicetify-best-moment", "main", "3fef2f55cd4cc16503165136a532ba717bee89b5", ""),
    ("MrPandir", "twitch-spotifi", "main", "45275758bd6621fdde6a5ba668729b1690533c8b", ""),
    ("muckelba", "dynamic-lights-homeassistant", "main", "ae796e93083dab2b69cf2d804e70058438be6a44", ""),
    ("mwaterman29", "spicetify-weighted-playlists", "main", "6a9b09b380633046bd395cf8231711bf9a10f1e6", ""),
    ("myanlll", "Friendify-ListenWithYourFriends", "main", "1e0202dfca22d54538693f36170f6779d004e50b", ""),
    ("NickColley", "spicetify-rewind", "main", "7e689a0b1ae1520add7da7e6dd75886e591bad61", ""),
    ("NigelMarshal", "spicetify-dancing-raccoon", "main", "ac04d6d1c8952c4f5223460abdc3ae1e2968ba08", ""),
    ("notPlancha", "volume-profiles-v2", "main", "490c20f1b12672a9eddc6aedd09ad161f14a4a97", ""),
    ("Nuzair46", "spicetify-raccoon-wheel", "main", "c0af71e4fadaac6b14d1774acb0d785f5b60fc1a", ""),
    ("obvRedwolf", "govee-dynamic-lights", "main", "0db65da9b09ccc55702060648ba2391a3f4619b9", ""),
    ("Oein", "beautifulfullscreen", "main", "039cdfbb95c1dce840c5b845966a15a3b378509e", ""),
    ("ohitstom", "spicetify-extensions", "main", "cd00aa6e76da4f82f9a013f1363b2a45f92b0a0b", ""),
    ("okanten", "playlistproxy-spicetify", "main", "2b46a4ee869a2fcea32a086afe574180d5de705a", ""),
    ("Om-Thorat", "Spicetify-extension", "main", "381be3b46fe8b508374c6c020e3392c34d5c6530", ""),
    ("Pithaya", "spicetify-apps", "main", "f47f22d1f00dc5d9f6afbe902019907266ca42b0", ""),
    ("Pl4neta", "allOfArtist", "main", "8368a584956ea15e008574fab609fd2efa7d9f44", ""),
    ("Plueres", "spicetify-extensions", "main", "17b7e4119dd953964316cd9aa97400e7bd11241b", ""),
    ("pnthach95", "spicetify-extensions", "main", "6749c9b18405df73e3b0100e221f5e29e7def234", ""),
    ("podpah", "Spicetify-Extensions", "main", "a3f838de7e7f4ae67914e41bb2e3a313bb413d14", ""),
    ("prochy-exe", "controlify-plugin", "main", "51d7830e0f5691454c5922e40ae1b19453e1db1c", "_1"),
    ("prochy-exe", "odesli-spicetify", "main", "d65bb6d0b5e6413b13b5a15990d2e544643e84dc", "_2"),
    ("qixing-jk", "spicetify-playlist-labels", "main", "68e9cddeab0fbd2a9666989f3183724efcfb7c65", ""),
    ("rastr1sr", "YoutubeKeybindsSpicetify", "main", "294e4b2e415a27754d9c0a183f3ca860af4fa3ae", ""),
    ("Resxt", "Spicetify-Extensions", "main", "75bd17ba1c9a19730f14529fb18857d7b9c7c12e", ""),
    ("Richie-Z", "romajin", "main", "c89c7ab62a275b28ba1e270e78fe3fb81e56586a", ""),
    ("Ruxery", "spicetify-autoplay", "main", "bf7c16952e5b05c7c3a0bf840b551655dc5f121d", ""),
    ("rxri", "spicetify-extensions", "main", "d1bc50363939723d80ccef51f1b14b0893cf1c14", ""),
    ("Samych02", "Resume-Playlist", "main", "8fb91156b0be6ecf7a30273ae5bedebf032681bf", ""),
    ("sanoojes", "spicetify-extensions", "main", "a2b6774426cf198165a13f0e5ed6996d0bbb3a0a", "-extensions"),
    ("SBijpost", "always-play-videos", "main", "b4e0bf2bd57a83381122bf6f40721cb69b296165", ""),
    ("ShadowAya", "spicetify-ledfx-color-sync", "main", "1a5accf733c0857cc56d8326a59fa89eb5d22696", ""),
    ("SIMULATAN", "Spicetify-Extensions", "main", "66e206ecbe40a6be71d363543a5ead6ecf99b727", ""),
    ("Socketlike", "spicetify-extensions", "main", "1532dc050044a8beb7d9af0a550dff37ddebb1fc", ""),
    ("Spicetify", "cli", "main", "465f6e36d02d3b142a871856b3ab7236fa31c263", "-cli"),
    ("Spikerko", "beautiful-lyrics", "main", "f6937b73f96597e9dda978de42f00c910cad087d", "_1"),
    ("Spikerko", "spicy-lyrics", "main", "56bd953fd684705f9584dc7f2657991a59597481", "_2"),
    ("Spikerko", "thepingpongballizer", "main", "5a7159bf5c5696d42325fa4364247e48f2acec46", "_3"),
    ("SunsetTechuila", "seekonscroll", "main", "32e0b383b35e5956b13e2469ce419cebd8e9be11", ""),
    ("surfbryce", "beautiful-lyrics", "main", "f6937b73f96597e9dda978de42f00c910cad087d", ""),
    ("SyndiShanX", "Spicetify-Extensions", "main", "2efad6de15d258d5fd4f74c3fcb25ec112ed0704", "-extensions"),
    ("szymonszewcjr", "legacyLook", "main", "3af99824607f97743ddd37361d7f1551bffc6f13", ""),
    ("Taeko-ar", "spicetify-last-fm", "main", "d2f1d3c1e286d789ddfa002f162405782d822c55", ""),
    ("TechShivvy", "spicetify-extensions", "main", "4ece6d5e9f16c4eebf956360b0f60e6651d57ac2", ""),
    ("Theblockbuster1", "spicetify-extensions", "main", "9452445b1f7b054ca7afeefcd3cb094cd89950e5", ""),
    ("TheGeeKing", "spicetify-extensions", "main", "364646df865a68a8db421272db848bf6ddf8112f", ""),
    ("theRealPadster", "spicetify-hide-podcasts", "main", "b935963574bd2bf126912fa478408bd7a26bd431", "-extensions"),
    ("thirtysomethings", "xcxcovers", "main", "f5a25b888ab505836f1fe23eeea20a3dc08e10a9", ""),
    ("tlozs", "spicetify-seekSongKeybinds", "main", "af7369c07dd3b507eee62be3b580677c702ec73b", ""),
    ("T0RNATO", "spotify-picture-in-picture", "main", "739baf321f1a18b11f55d2356b7d41ebd2e4ed36", ""),
    ("Undead34", "spicetify-extensions", "main", "5720a0604de716194e3aa844b96952dc7190102c", ""),
    ("vbalien", "spicetify-extension-autoSkipPattern", "main", "91f94bf53cdc9c4d43d4d9b47ea1b43d420e239a", ""),
    ("Vexcited", "better-spotify-genres", "build", "3cf6e63450261b53f814efc74f7f7af9c749d699", ""),
    ("WaddlesPlays", "SpicetifyStuff", "main", "688fa3b256ec13faae0a89ca8b42055b4c781b51", ""),
    ("x1yl", "BetterSpicetifyAOTYScores", "main", "40e8265b9b2a5da8b20ea1d0cf92534669e5dbbc", ""),
    ("yodaluca23", "spicetify-extensions", "main", "007754f0bcb284d39aa03cf0348a9d22df697225", ""),
    # ("owner", "repo", "branch", "revision", "suffix (for multiple repos with same owner)"),
]

# Create the data structure
data = {
    "pins": {f"{owner}{suffix}": generate_repository_data(owner, repo, branch, revision, suffix) for owner, repo, branch, revision, suffix in repositories},
    "version": 5
}

# Specify the file name
file_name = 'extSources.json'

# Write the JSON data to a file
with open(file_name, 'w') as json_file:
    json.dump(data, json_file, indent=2)

print(f"JSON data has been written to {file_name}")
