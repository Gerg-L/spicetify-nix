{
  source,
  lib,
  ...
}:
with source; let
  # EXTENSIONS ----------------------------------------------------------------
  brokenAdblock = {
    src = spotifyNoPremiumSrc;
    filename = "adblock.js";
  };

  savePlaylists = {
    src = "${dakshExtensions}/Extensions";
    filename = "savePlaylists.js";
  };
  fullScreen = {
    src = "${dakshExtensions}/Extensions/full-screen/dist";
    filename = "fullScreen.js";
  };
  autoSkip = {
    src = "${dakshExtensions}/Extensions/auto-skip/dist";
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
  oldSidebar = {
    src = "${charlieS1103Src}/old-sidebar";
    filename = "oldSidebar.js";
  };
  wikify = {
    src = "${charlieS1103Src}/wikify";
    filename = "wikify.js";
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
    src = "${huhExtensionsSrc}/fullAppDisplayModified";
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

  charliesAdblock = {
    src = "${charlieS1103Src}/adblock";
    filename = "adblock.js";
  };

  # UNUSED
  # startpage needs r/w
  # startPage = {
  #   src = "${startPageSrc}/dist";
  #   filename = "startup-page.js";
  # };

  sanitizeName = lib.replaceStrings [".js" "+"] ["" ""];

  warnExt = {
    ext,
    alias ? ext.filename,
  }:
    lib.trivial.warn
    "You are referring to extension ${alias} by filename. This behavior is deprecated, please use spicetify-nix.packages.$\{pkgs.system}.default.extensions.${sanitizeName ext.filename}"
    ext;

  mkExtAlias = alias: ext:
    {
      ${alias} = warnExt {inherit ext alias;};
      ${sanitizeName ext.filename} = ext;
    }
    // (
      if alias != ext.filename
      then {${sanitizeName alias} = ext;}
      else {}
    );

  appendJS = ext: mkExtAlias ext.filename ext;
in
  {
    official = let
      mkOfficialExt = name: {
        "${name}.js" = {
          src = "${officialSrc}/Extensions";
          filename = "${name}.js";
        };
        ${sanitizeName name} = {
          src = "${officialSrc}/Extensions";
          filename = "${name}.js";
        };
      };
    in
      mkOfficialExt "autoSkipExplicit"
      // mkOfficialExt "autoSkipVideo"
      // mkOfficialExt "bookmark"
      // mkOfficialExt "fullAppDisplay"
      // mkOfficialExt "keyboardShortcut"
      // mkOfficialExt "loopyLoop"
      // mkOfficialExt "popupLyrics"
      // mkOfficialExt "shuffle+"
      // mkOfficialExt "trashbin"
      // mkOfficialExt "webnowplaying";
    _lib = {
      inherit sanitizeName;
    };
  }
  # aliases for weirdly named extension files
  // mkExtAlias "history.js" history
  // mkExtAlias "volumeProfiles.js" volumeProfiles
  // mkExtAlias "copyToClipboard.js" copyToClipboard
  // mkExtAlias "songStats.js" songStats
  // mkExtAlias "featureShuffle.js" featureShuffle
  // mkExtAlias "playlistIcons.js" playlistIcons
  // mkExtAlias "powerBar.js" powerBar
  // mkExtAlias "groupSession.js" groupSession
  // mkExtAlias "brokenAdblock.js" brokenAdblock # this is old but you can still use it if you need
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
  // appendJS charliesAdblock # adblock.js
  // appendJS savePlaylists
  // appendJS autoSkip
  // appendJS fullScreen
  // appendJS playNext
  // appendJS volumePercentage
  // appendJS oldSidebar
