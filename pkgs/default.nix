{ pkgs, lib, ... }:
let
  spiceTypes = (import ../lib { inherit pkgs lib; }).types;

  # SOURCE --------------------------------------------------------------------
  officialThemes = pkgs.fetchgit {
    url = "https://github.com/spicetify/spicetify-themes";
    rev = "9a2fcb5a545da368e4bf1d8189f58d0f664f3115";
    sha256 = "18gmhahw7k4labygq3a4igqbkwqzlr67s7xvnf75521ynnzpnhca";
  };

  officialSrc = pkgs.fetchgit {
    url = "https://github.com/spicetify/spicetify-cli";
    rev = "6f473f28151c75e08e83fb280dd30fadd22d9c04";
    sha256 = "0vw0271vbvpgyb0y97lafc5hqpfy5947zm7r2wlg17f8w94vsfhv";
  };

  catppuccinSrc = pkgs.fetchgit {
    url = "https://github.com/catppuccin/spicetify";
    rev = "8aaacc4b762fb507b3cf7d4d1b757eb849fcbb52";
    sha256 = "185fbh958k985ci3sf4rdxxkwbk61qmzjhd6m54h9rrsrmh5px69";
  };

  spotifyNoPremiumSrc = pkgs.fetchgit {
    url = "https://github.com/Daksh777/SpotifyNoPremium";
    rev = "a2daa7a9ec3e21ebba3c6ab0ad1eb5bd8e51a3ca";
    sha256 = "1sr6pjaygxxx6majmk5zg8967jry53z6xd6zc31ns2g4r5sy4k8d";
  };

  comfySrc = pkgs.fetchgit {
    url = "https://github.com/Comfy-Themes/Spicetify";
    rev = "45830ed853cc212dec0c053deb34da6aefc25ce5";
    sha256 = "1hb9f1nwf0jw5yvrzy2bshpb89h1aaysf18zvs0g5fmhmvn7ba6s";
  };

  fluentSrc = pkgs.fetchgit {
    url = "https://github.com/williamckha/spicetify-fluent";
    rev = "47c13bfa2983643a14229c5ecbb88d5001c91c6b";
    sha256 = "0pcx9wshrx0hp3rcjrhi7676baskp8r10bcahp6nr105s42d8x5z";
  };

  defaultDynamicSrc = pkgs.fetchgit {
    url = "https://github.com/JulienMaille/spicetify-dynamic-theme";
    rev = "b21c35c0695b1baebbbe446a0a02ec40d4c5279e";
    sha256 = "0qlkvazciqr62z7vc6fdvy6hn2mgn3blj13fi3a82vg5jb70mgxm";
  };

  retroBlurSrc = pkgs.fetchgit {
    url = "https://github.com/Motschen/Retroblur";
    rev = "a1add2945cf753bbc32108b561faa09ef8af7183";
    sha256 = "1g7aqg21arl05s69ywb1qkiva17gldisdmvxin85yiv14pahj06p";
  };

  omniSrc = pkgs.fetchgit {
    url = "https://github.com/getomni/spicetify";
    rev = "1c8cbf99cdea93f3a0e8297ddfb681e58551d51d";
    sha256 = "0s9avj0gq206hcj8qri025avv12pmmlswyffkxq6s2y2mi9wp0h7";
  };

  bloomSrc = pkgs.fetchgit {
    url = "https://github.com/nimsandu/spicetify-bloom";
    rev = "c8f69180a3bcd0cc27b9e6bd84fc5c0996b5ccc0";
    sha256 = "1g11n6qf8xqgpr5jy5wswdf0cy128mwrxixm713291ac3jcdl8in";
  };

  orchisSrc = pkgs.fetchgit {
    url = "https://github.com/canbeardig/Spicetify-Orchis-Colours-v2";
    rev = "5bf3fcf0696514dcf3e95f4ae3fd00261ccc5dcc";
    sha256 = "1fzmxgjb3l6qn6a7zc621pqhh5m5xzjj1wqplk4rwnrrb1d3digm";
  };

  draculaSrc = pkgs.fetchgit {
    url = "https://github.com/Darkempire78/Dracula-Spicetify";
    rev = "97bf149e7afbe408509862591a57f1d8e2dfc5d7";
    sha256 = "0l7la5hmhzfzf0n6lk3zxc4bc9f2h2dcwx02r6yqnrnkkkzh0b91";
  };

  nordSrc = pkgs.fetchgit {
    url = "https://github.com/Tetrax-10/Nord-Spotify";
    rev = "54808ec21a87db3c7c11e2a4e86fca6d45c50c9e";
    sha256 = "0sqgbdkd3cjjh5zdfadnsd4zfscqhx2pbinzfn26v99fsla18kv3";
  };

  dakshExtensions = pkgs.fetchgit {
    url = "https://github.com/daksh2k/Spicetify-stuff";
    rev = "2a4d0be5fecf449c1f6dd57950c2ca3ba2e71635";
    sha256 = "12axk85h30i5a6b0sa75g85bamhcvnyqj6zgv2irgk9f3m5018ck";
  };

  hidePodcastsSrc = pkgs.fetchgit {
    url = "https://github.com/theRealPadster/spicetify-hide-podcasts";
    rev = "cfda4ce0c3397b0ec38a971af4ff06daba71964d";
    sha256 = "146bz9v94dk699bshbc21yq4y5yc38lq2kkv7w3sjk4x510i0v3q";
  };

  historySrc = pkgs.fetchgit {
    url = "https://github.com/einzigartigerName/spicetify-history";
    rev = "577e34f364127f18d917d2fe2e8c8f2a1af9f6ae";
    sha256 = "0fv5fb6k9zc446a1lznhmd68m47sil5pqabv4dmrqk6cvfhba49r";
  };

  genreSrc = pkgs.fetchgit {
    url = "https://github.com/Shinyhero36/Spicetify-Genre";
    rev = "4ab66852825525869ef5ced5747e7e84ddd0a8bb";
    sha256 = "09b69dcknqvj9nc5ayfqcdg63vc5yshn0wa23gyachzicwalq30m";
  };

  lastfmSrc = pkgs.fetchgit {
    url = "https://github.com/LucasBares/spicetify-last-fm";
    rev = "0f905b49362ea810b6247ac1950a2951dd35632e";
    sha256 = "1b0l2g5cyjj1nclw1ff7as9q94606mkq1k8l2s34zzdsx3m2zv81";
  };

  localFilesSrc = pkgs.fetchgit {
    url = "https://github.com/hroland/spicetify-show-local-files/";
    rev = "1bfd2fc80385b21ed6dd207b00a371065e53042e";
    sha256 = "01gy16b69glqcalz1wm8kr5wsh94i419qx4nfmsavm4rcvcr3qlx";
  };

  autoVolumeSrc = pkgs.fetchFromGitHub {
    owner = "amanharwara";
    repo = "spicetify-autoVolume";
    rev = "d7f7962724b567a8409ef2898602f2c57abddf5a";
    sha256 = "1pnya2j336f847h3vgiprdys4pl0i61ivbii1wyb7yx3wscq7ass";
  };

  customAppsExtensionsSrc = pkgs.fetchgit {
    url = "https://github.com/3raxton/spicetify-custom-apps-and-extensions";
    rev = "0f5e79fe43abf57f714d7d00bd288870d5b6f718";
    sha256 = "1kjzaczp9p88jkf9jxkh3wrdydz9vhfljh6yaywzqsa2qz7zycp3";
  };

  spotifyCanvasSrc = pkgs.fetchgit {
    url = "https://github.com/itsmeow/Spicetify-Canvas";
    rev = "052926a51d7586fc107ac650a61dfa0b1669c3eb";
    sha256 = "1xczz5zd7275hcdg4hgqvcynbrkn4mx6g5vz6fylddvp275h3fn6";
  };

  charlieS1103Src = pkgs.fetchgit {
    url = "https://github.com/CharlieS1103/spicetify-extensions";
    rev = "40b8c13722ca92ce71ccbd27645e47da92ee25ec";
    sha256 = "05v9c9vzdk2maqhzyzr0fd5nhv5im1cvspmly3j04p8k92hic33v";
  };

  huhExtensionsSrc = pkgs.fetchgit {
    url = "https://github.com/huhridge/huh-spicetify-extensions";
    rev = "332c6ec9089aa6d5afd911644a649467e4698852";
    sha256 = "0yrsicfdb571z7p6fayh9f4zy65y18ff63g6lcs74ir0pv2hqllq";
  };

  playlistIconsSrc = pkgs.fetchgit {
    url = "https://github.com/jeroentvb/spicetify-playlist-icons";
    rev = "9ccb8b677eb139dbc3bdd10f1d9bec25c3a6144e";
    sha256 = "18ai0l0j3kswy33m7w7bdw5k39f0cfm4hbxndgk4dkljsi5k31nv";
  };

  tetraxSrc = pkgs.fetchgit {
    url = "https://github.com/Tetrax-10/Spicetify-Extensions";
    rev = "928ea55b6129da2ff68a1bc28e1054a8380a6d1e";
    sha256 = "001h2f137vq8a6l9id05nkh7nw7cbajn5s6a80wlhmm2g03rhm7k";
  };

  powerBarSrc = pkgs.fetchgit {
    url = "https://github.com/jeroentvb/spicetify-power-bar";
    rev = "bea0d0d05271c543a41e7e464e8b9a3bd3de3003";
    sha256 = "09g72nlapqaal1rsd4x1nh0g6dg9286hqfxq1439r7k7fqa5hwc7";
  };

  groupSessionSrc = pkgs.fetchgit {
    url = "https://github.com/timll/spotify-group-session";
    rev = "06c5b218ccec3e50b8b1d5f067898727d96e672b";
    sha256 = "1kcpkvijjkmgq9gl62a93yhgs77z7c1xyv3x6h03bhpd94ccyycd";
  };

  startPageSrc = pkgs.fetchgit {
    url = "https://github.com/Resxt/startup-page";
    rev = "cca2b29e690dad4d8b89f0ba994b2f9a714f4e6a";
    sha256 = "1qqar6lcq1djbiwgsjd7sd5r8061fkwfy92yfvh3b7i9q939djf5";
  };

  # EXTENSIONS ----------------------------------------------------------------

  dribbblishExt = {
    filename = "dribbblish.js";
    src = "${officialThemes}/Dribbblish";
  };

  turntableExt = {
    filename = "turntable.js";
    src = "${officialThemes}/Turntable";
  };

  adblock = {
    src = spotifyNoPremiumSrc;
    filename = "adblock.js";
  };

  savePlaylists = {
    src = "${dakshExtensions}/Extensions";
    filename = "savePlaylists.js";
  };
  fullScreen = {
    src = "${dakshExtensions}/Extensions";
    filename = "fullScreen.js";
  };
  autoSkip = {
    src = "${dakshExtensions}/Extensions";
    filename = "autoSkip.js";
  };
  playNext = {
    src = "${dakshExtensions}/Extensions";
    filename = "playNext.js";
  };
  volumePercentage = {
    src = "${dakshExtensions}/Extensions";
    filename = "volumePercentage.js";
  };

  hidePodcasts = {
    src = hidePodcastsSrc;
    filename = "hidePodcasts.js";
  };
  history = {
    src = historySrc;
    filename = "historyShortcut.js";
  };
  genre = {
    src = genreSrc;
    filename = "genre.js";
  };
  lastfm = {
    src = "${lastfmSrc}/src";
    filename = "lastfm.js";
  };

  autoVolume = {
    src = autoVolumeSrc;
    filename = "autoVolume.js";
  };

  copyToClipboard = {
    src = "${customAppsExtensionsSrc}/v2/copy-to-clipboard";
    filename = "copytoclipboard2.js";
  };
  showQueueDuration = {
    src = "${customAppsExtensionsSrc}/v2/show-queue-duration";
    filename = "showQueueDuration.js";
  };
  volumeProfiles = {
    src = "${customAppsExtensionsSrc}/v2/volume-profiles/dist";
    filename = "volume-profiles.js";
  };

  songStats = {
    src = "${charlieS1103Src}/songstats";
    filename = "songstats.js";
  };
  featureShuffle = {
    src = "${charlieS1103Src}/featureshuffle";
    filename = "featureshuffle.js";
  };
  wikify = {
    src = "${charlieS1103Src}/wikify";
    filename = "wikify.js";
  };
  fixEnhance = {
    src = "${charlieS1103Src}/fixEnhance";
    filename = "fixEnhance.js";
    experimentalFeatures = true;
  };
  phraseToPlaylist = {
    src = "${charlieS1103Src}/phraseToPlaylist";
    filename = "phraseToPlaylist.js";
  };

  fullAlbumDate = {
    src = "${huhExtensionsSrc}/fullAlbumDate";
    filename = "fullAlbumDate.js";
  };
  fullAppDisplayMod = {
    src = "${huhExtensionsSrc}/fullAppDisplayMod";
    filename = "fullAppDisplayMod.js";
  };
  goToSong = {
    src = "${huhExtensionsSrc}/goToSong";
    filename = "goToSong.js";
  };
  listPlaylistsWithSong = {
    src = "${huhExtensionsSrc}/listPlaylistsWithSong";
    filename = "listPlaylistsWithSong.js";
  };
  playlistIntersection = {
    src = "${huhExtensionsSrc}/playlistIntersection";
    filename = "playlistIntersection.js";
  };
  skipStats = {
    src = "${huhExtensionsSrc}/skipStats";
    filename = "skipStats.js";
  };
  playlistIcons = {
    src = playlistIconsSrc;
    filename = "playlist-icons.js";
  };

  seekSong = {
    src = "${tetraxSrc}/Seek-Song";
    filename = "seekSong.js";
  };
  skipOrPlayLikedSongs = {
    src = "${tetraxSrc}/Skip-or-Play-Liked-Songs";
    filename = "skipOrPlayLikedSongs.js";
  };

  powerBar = {
    src = powerBarSrc;
    filename = "power-bar.js";
  };
  # TODO: add user.css additions as part of extensions, for snippets
  # powerBar can by styled with the following CSS:
  # #power-bar-container {
  #   --power-bar-background-color: #333333;
  #   --power-bar-main-text-color: #ffffff;
  #   --power-bar-subtext-color: #b3b3b3;
  #   --power-bar-active-background-color: #1db954;
  #   --power-bar-active-text-color: #121212;
  #   --power-bar-border-color: #000000;
  # }

  groupSession = {
    src = "${groupSessionSrc}/src";
    filename = "group-session.js";
  };


  # UNUSED
  # we already have an adblock
  charliesAdblock = {
    src = "${charlieS1103Src}/adblock";
    filename = "adblock.js";
  };
  # startpage needs r/w
  startPage = {
    src = "${startPageSrc}/dist";
    filename = "startup-page.js";
  };


  # THEME GENERATORS ----------------------------------------------------------

  mkCatppuccinTheme = name: {
    ${name} = {
      inherit name;
      src = catppuccinSrc;
      appendName = true;
      requiredExtensions = [
        {
          src = "${catppuccinSrc}/js";
          filename = "${name}.js";
        }
      ];
      injectCss = true;
      replaceColors = true;
      overwriteAssets = true;
    };
  };
  mkComfyTheme = name: {
    ${name} =
      let lname = lib.strings.toLower name; in
      {
        inherit name;
        src = comfySrc;
        appendName = true;
        injectCss = true;
        replaceColors = true;
        overwriteAssets = true;
        requiredExtensions = [
          {
            src = "${comfySrc}/${name}";
            filename = "${lname}.js";
          }
        ];
        extraCommands = ''
          # remove the auto-update functionality
          echo "\n" >> ./Extensions/${lname}.js
          cat ./Themes/${name}/${lname}.script.js >> ./Extensions/${lname}.js
        '';
      };
  };

  # THEMES --------------------------------------------------------------------

  SpotifyNoPremium = {
    name = "SpotifyNoPremium";
    src = spotifyNoPremiumSrc;
    appendName = false;
    requiredExtensions = [ adblock ];
  };

  Fluent = {
    name = "Fluent";
    src = fluentSrc;
    appendName = false;
    injectCss = true;
    overwriteAssets = true;
    replaceColors = true;
    patches = {
      "xpui.js_find_8008" = ",(\\w+=)32";
      "xpui.js_repl_8008" = ",$\{1}56";
    };
    requiredExtensions = [
      {
        src = fluentSrc;
        filename = "fluent.js";
      }
    ];
  };

  DefaultDynamic = {
    name = "DefaultDynamic";
    src = defaultDynamicSrc;
    appendName = false;
    injectCss = true;
    replaceColors = true;
    requiredExtensions = [
      {
        src = defaultDynamicSrc;
        filename = "default-dynamic.js";
      }
      {
        src = defaultDynamicSrc;
        filename = "Vibrant.min.js";
      }
    ];
    patches = {
      "xpui.js_find_8008" = ",(\\w+=)32,";
      "xpui.js_repl_8008" = ",$\{1}28,";
    };
  };

  RetroBlur = {
    name = "RetroBlur";
    src = retroBlurSrc;
    appendName = false;
    injectCss = true;
    replaceColors = true;
  };

  # BROKEN. no clue why
  Omni = {
    name = "Omni";
    src = omniSrc;
    appendName = false;
    injectCss = true;
    overwriteAssets = true;
    replaceColors = true;
    requiredExtensions = [
      {
        src = omniSrc;
        filename = "omni.js";
      }
    ];
  };

  # light colorscheme is broken, think that's the theme's fault
  Bloom = {
    name = "Bloom";
    src = bloomSrc;
    appendName = false;
    injectCss = true;
    replaceColors = true;
    overwriteAssets = true;
    patches = {
      "xpui.js_find_8008" = ",(\\w+=)32,";
      "xpui.js_repl_8008" = ",$\{1}56,";
    };
    requiredExtensions = [
      {
        src = bloomSrc;
        filename = "bloom.js";
      }
    ];
  };

  Orchis = {
    name = "DarkGreen";
    src = orchisSrc;
    appendName = true;
    injectCss = true;
    replaceColors = true;
  };

  Dracula = {
    name = "Dracula";
    src = draculaSrc;
    appendName = true;
    replaceColors = true;
  };

  Nord = {
    name = "Nord";
    src = nordSrc;
    appendName = false;
    injectCss = true;
    replaceColors = true;
  };

  # theres a thing at https://github.com/itsmeow/Spicetify-Canvas
  # about getting a custom build of chromium or something. I am NOT doing that
  # ... but maybe one day if someone asks
  # TODO: add the ability to append this user.css to any other user.css
  # for installation in any theme
  SpotifyCanvas = {
    name = "SpotifyCanvas";
    src = "${spotifyCanvasSrc}/Themes/canvas";
    appendName = false;
    injectCss = true;

    requiredExtensions = [
      {
        src = "${spotifyCanvasSrc}/Extensions";
        filename = "getCanvas.js";
      }
    ];
  };

  # CUSTOMAPPS ----------------------------------------------------------------
  localFiles = {
    name = "localFiles";
    src = localFilesSrc;
    appendName = false;
  };

  # OFFICIAL THEMES AND EXTENSIONS --------------------------------------------

  official = {
    themes =
      let
        mkOfficialTheme = themeName: { ${themeName} = { name = themeName; src = officialThemes; }; };
      in
      {
        Dribbblish = {
          name = "Dribbblish";
          src = officialThemes;
          requiredExtensions = [ dribbblishExt ];
          patches = {
            "xpui.js_find_8008" = ",(\\w+=)32";
            "xpui.js_repl_8008" = ",$\{1}56";
          };
          injectCss = true;
          replaceColors = true;
          overwriteAssets = true;
          appendName = true;
          sidebarConfig = true;
        };

        Dreary = {
          name = "Dreary";
          src = officialThemes;
          sidebarConfig = true;
          appendName = true;
        };
        Glaze = {
          name = "Glaze";
          src = officialThemes;
          sidebarConfig = true;
          appendName = true;
        };
        Turntable = {
          name = "Turntable";
          src = officialThemes;
          requiredExtensions = [ "fullAppDisplay.js" turntableExt ];
        };
      } //
      mkOfficialTheme "Ziro" //
      mkOfficialTheme "Sleek" //
      mkOfficialTheme "Onepunch" //
      mkOfficialTheme "Flow" //
      mkOfficialTheme "Default" //
      mkOfficialTheme "BurntSienna";

    extensions =
      let
        mkOfficialExt = name: { "${name}.js" = { src = "${officialSrc}/Extensions"; filename = "${name}.js"; }; };
      in
      {
        "dribbblish.js" = dribbblishExt;
        "turntable.js" = turntableExt;
      }
      // mkOfficialExt "autoSkipExplicit"
      // mkOfficialExt "autoSkipVideo"
      // mkOfficialExt "bookmark"
      // mkOfficialExt "fullAppDisplay"
      // mkOfficialExt "keyboardShortcut"
      // mkOfficialExt "loopyLoop"
      // mkOfficialExt "popupLyrics"
      // mkOfficialExt "shuffle+"
      // mkOfficialExt "trashbin"
      // mkOfficialExt "webnowplaying";

    apps = {
      new-releases = {
        src = "${officialSrc}/CustomApps";
        name = "new-releases";
      };
      reddit = {
        src = "${officialSrc}/CustomApps";
        name = "reddit";
      };
      lyrics-plus = {
        src = "${officialSrc}/CustomApps";
        name = "lyrics-plus";
      };
    };
  };
  appendJS = ext: { ${ext.filename} = ext; };
in
{
  inherit official;
  themes = {
    inherit SpotifyNoPremium Fluent DefaultDynamic RetroBlur Omni Bloom Orchis
      Dracula Nord SpotifyCanvas;
  } // official.themes
  // mkCatppuccinTheme "catppuccin-mocha"
  // mkCatppuccinTheme "catppuccin-frappe"
  // mkCatppuccinTheme "catppuccin-latte"
  // mkCatppuccinTheme "catppuccin-macchiato"
  // mkComfyTheme "Comfy"
  // mkComfyTheme "Comfy-Chromatic"
  // mkComfyTheme "Comfy-Mono";
  extensions = {
    # aliases for weirdly named extension files
    "history.js" = history;
    "volumeProfiles.js" = volumeProfiles;
    "copyToClipboard.js" = copyToClipboard;
    "songStats.js" = songStats;
    "featureShuffle.js" = featureShuffle;
    "playlistIcons.js" = playlistIcons;
    "powerBar.js" = powerBar;
    "groupSession.js" = groupSession;
  } // official.extensions
  // appendJS groupSession
  // appendJS powerBar
  // appendJS seekSong
  // appendJS skipOrPlayLikedSongs
  // appendJS playlistIcons
  // appendJS fullAlbumDate
  // appendJS fullAppDisplayMod
  // appendJS goToSong
  // appendJS listPlaylistsWithSong
  // appendJS playlistIntersection
  // appendJS skipStats
  // appendJS phraseToPlaylist
  // appendJS fixEnhance
  // appendJS wikify
  // appendJS featureShuffle
  // appendJS songStats
  // appendJS showQueueDuration
  // appendJS copyToClipboard
  // appendJS volumeProfiles
  // appendJS autoVolume
  // appendJS history
  // appendJS lastfm
  // appendJS genre
  // appendJS hidePodcasts
  // appendJS adblock
  // appendJS savePlaylists
  // appendJS autoSkip
  // appendJS fullScreen
  // appendJS playNext
  // appendJS volumePercentage;
  apps = { inherit localFiles; } // official.apps;
}
