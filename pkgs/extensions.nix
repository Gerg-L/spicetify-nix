{ sources, pkgs }:

let
  inherit (pkgs) lib;
  # EXTENSIONS ----------------------------------------------------------------
  savePlaylists = {
    src = "${sources.dakshExtensions}/Extensions";
    name = "savePlaylists.js";
  };
  fullScreen = {
    src = "${sources.dakshExtensions}/Extensions/full-screen/dist";
    name = "fullScreen.js";
  };
  autoSkip = {
    src = "${sources.dakshExtensions}/Extensions/auto-skip/dist";
    name = "autoSkip.js";
  };
  playNext = {
    src = "${sources.dakshExtensions}/Extensions";
    name = "playNext.js";
  };
  volumePercentage = {
    src = "${sources.dakshExtensions}/Extensions";
    name = "volumePercentage.js";
  };

  hidePodcasts = {
    src = sources.hidePodcastsSrc;
    name = "hidePodcasts.js";
  };
  history = {
    src = sources.historySrc;
    name = "historyShortcut.js";
  };
  betterGenres = {
    src = sources.betterGenresSrc;
    name = "spotifyGenres.js";
  };
  lastfm = {
    src = "${sources.lastfmSrc}/src";
    name = "lastfm.js";
  };

  autoVolume = {
    src = sources.autoVolumeSrc;
    name = "autoVolume.js";
  };

  copyToClipboard = {
    src = "${sources.customAppsExtensionsSrc}/v2/copy-to-clipboard";
    name = "copytoclipboard2.js";
  };
  showQueueDuration = {
    src = "${sources.customAppsExtensionsSrc}/v2/show-queue-duration";
    name = "showQueueDuration.js";
  };
  volumeProfiles = {
    src = "${sources.customAppsExtensionsSrc}/v2/volume-profiles/dist";
    name = "volume-profiles.js";
  };

  songStats = {
    src = "${sources.rxriSrc}/songstats";
    name = "songstats.js";
  };
  featureShuffle = {
    src = "${sources.rxriSrc}/featureshuffle";
    name = "featureshuffle.js";
  };
  oldSidebar = {
    src = "${sources.rxriSrc}/old-sidebar";
    name = "oldSidebar.js";
  };
  wikify = {
    src = "${sources.rxriSrc}/wikify";
    name = "wikify.js";
  };
  phraseToPlaylist = {
    src = "${sources.rxriSrc}/phraseToPlaylist";
    name = "phraseToPlaylist.js";
  };

  fullAlbumDate = {
    src = "${sources.huhExtensionsSrc}/fullAlbumDate";
    name = "fullAlbumDate.js";
  };
  fullAppDisplayMod = {
    src = "${sources.huhExtensionsSrc}/fullAppDisplayModified";
    name = "fullAppDisplayMod.js";
  };
  goToSong = {
    src = "${sources.huhExtensionsSrc}/goToSong";
    name = "goToSong.js";
  };
  listPlaylistsWithSong = {
    src = "${sources.huhExtensionsSrc}/listPlaylistsWithSong";
    name = "listPlaylistsWithSong.js";
  };
  playlistIntersection = {
    src = "${sources.huhExtensionsSrc}/playlistIntersection";
    name = "playlistIntersection.js";
  };
  skipStats = {
    src = "${sources.huhExtensionsSrc}/skipStats";
    name = "skipStats.js";
  };
  playlistIcons = {
    src = sources.playlistIconsSrc;
    name = "playlist-icons.js";
  };

  seekSong = {
    src = "${sources.tetraxSrc}/Seek-Song";
    name = "seekSong.js";
  };
  skipOrPlayLikedSongs = {
    src = "${sources.tetraxSrc}/Skip-or-Play-Liked-Songs";
    name = "skipOrPlayLikedSongs.js";
  };

  powerBar = {
    src = sources.powerBarSrc;
    name = "power-bar.js";
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
    src = "${sources.groupSessionSrc}/src";
    name = "group-session.js";
  };

  charliesAdblock = {
    src = "${sources.rxriSrc}/adblock";
    name = "adblock.js";
  };

  sanitizeName =
    lib.replaceStrings
      [
        ".js"
        "+"
      ]
      [
        ""
        ""
      ];

  mkExtAlias =
    alias: ext:
    {
      ${sanitizeName ext.name} = ext;
    }
    // lib.optionalAttrs (alias != ext.name) { ${sanitizeName alias} = ext; };
in
(lib.listToAttrs (
  map
    (x: {
      name = sanitizeName x;
      value = {
        src = "${sources.officialSrc}/Extensions";
        name = "${x}.js";
      };
    })
    [
      "autoSkipExplicit"
      "autoSkipVideo"
      "bookmark"
      "fullAppDisplay"
      "keyboardShortcut"
      "loopyLoop"
      "popupLyrics"
      "shuffle+"
      "trashbin"
      "webnowplaying"
    ]
))
//

  #append .js
  lib.attrsets.mergeAttrsList (
    map (x: mkExtAlias x.name x) [
      groupSession
      powerBar
      seekSong
      skipOrPlayLikedSongs
      playlistIcons
      fullAlbumDate
      fullAppDisplayMod
      goToSong
      listPlaylistsWithSong
      playlistIntersection
      skipStats
      phraseToPlaylist
      wikify
      featureShuffle
      songStats
      showQueueDuration
      copyToClipboard
      volumeProfiles
      autoVolume
      history
      betterGenres
      lastfm
      hidePodcasts
      charliesAdblock # adblock.js
      savePlaylists
      autoSkip
      fullScreen
      playNext
      volumePercentage
      oldSidebar
    ]

  )
# aliases for weirdly named extension files
// (mkExtAlias "history.js" history)
// (mkExtAlias "volumeProfiles.js" volumeProfiles)
// (mkExtAlias "copyToClipboard.js" copyToClipboard)
// (mkExtAlias "songStats.js" songStats)
// (mkExtAlias "betterGenres.js" betterGenres)
// (mkExtAlias "featureShuffle.js" featureShuffle)
// (mkExtAlias "playlistIcons.js" playlistIcons)
// (mkExtAlias "powerBar.js" powerBar)
// (mkExtAlias "groupSession.js" groupSession)
