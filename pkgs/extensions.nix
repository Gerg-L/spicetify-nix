{source, lib}:
let
  # EXTENSIONS ----------------------------------------------------------------
  savePlaylists = {
    src = "${source.dakshExtensions}/Extensions";
    filename = "savePlaylists.js";
  };
  fullScreen = {
    src = "${source.dakshExtensions}/Extensions/full-screen/dist";
    filename = "fullScreen.js";
  };
  autoSkip = {
    src = "${source.dakshExtensions}/Extensions/auto-skip/dist";
    filename = "autoSkip.js";
  };
  playNext = {
    src = "${source.dakshExtensions}/Extensions";
    filename = "playNext.js";
  };
  volumePercentage = {
    src = "${source.dakshExtensions}/Extensions";
    filename = "volumePercentage.js";
  };

  hidePodcasts = {
    src = source.hidePodcastsSrc;
    filename = "hidePodcasts.js";
  };
  history = {
    src = source.historySrc;
    filename = "historyShortcut.js";
  };
  lastfm = {
    src = "${source.lastfmSrc}/src";
    filename = "lastfm.js";
  };

  autoVolume = {
    src = source.autoVolumeSrc;
    filename = "autoVolume.js";
  };

  copyToClipboard = {
    src = "${source.customAppsExtensionsSrc}/v2/copy-to-clipboard";
    filename = "copytoclipboard2.js";
  };
  showQueueDuration = {
    src = "${source.customAppsExtensionsSrc}/v2/show-queue-duration";
    filename = "showQueueDuration.js";
  };
  volumeProfiles = {
    src = "${source.customAppsExtensionsSrc}/v2/volume-profiles/dist";
    filename = "volume-profiles.js";
  };

  songStats = {
    src = "${source.charlieS1103Src}/songstats";
    filename = "songstats.js";
  };
  featureShuffle = {
    src = "${source.charlieS1103Src}/featureshuffle";
    filename = "featureshuffle.js";
  };
  oldSidebar = {
    src = "${source.charlieS1103Src}/old-sidebar";
    filename = "oldSidebar.js";
  };
  wikify = {
    src = "${source.charlieS1103Src}/wikify";
    filename = "wikify.js";
  };
  phraseToPlaylist = {
    src = "${source.charlieS1103Src}/phraseToPlaylist";
    filename = "phraseToPlaylist.js";
  };

  fullAlbumDate = {
    src = "${source.huhExtensionsSrc}/fullAlbumDate";
    filename = "fullAlbumDate.js";
  };
  fullAppDisplayMod = {
    src = "${source.huhExtensionsSrc}/fullAppDisplayModified";
    filename = "fullAppDisplayMod.js";
  };
  goToSong = {
    src = "${source.huhExtensionsSrc}/goToSong";
    filename = "goToSong.js";
  };
  listPlaylistsWithSong = {
    src = "${source.huhExtensionsSrc}/listPlaylistsWithSong";
    filename = "listPlaylistsWithSong.js";
  };
  playlistIntersection = {
    src = "${source.huhExtensionsSrc}/playlistIntersection";
    filename = "playlistIntersection.js";
  };
  skipStats = {
    src = "${source.huhExtensionsSrc}/skipStats";
    filename = "skipStats.js";
  };
  playlistIcons = {
    src = source.playlistIconsSrc;
    filename = "playlist-icons.js";
  };

  seekSong = {
    src = "${source.tetraxSrc}/Seek-Song";
    filename = "seekSong.js";
  };
  skipOrPlayLikedSongs = {
    src = "${source.tetraxSrc}/Skip-or-Play-Liked-Songs";
    filename = "skipOrPlayLikedSongs.js";
  };

  powerBar = {
    src = source.powerBarSrc;
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
    src = "${source.groupSessionSrc}/src";
    filename = "group-session.js";
  };

  charliesAdblock = {
    src = "${source.charlieS1103Src}/adblock";
    filename = "adblock.js";
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
      ${sanitizeName ext.filename} = ext;
    }
    // lib.optionalAttrs (alias != ext.filename) {${sanitizeName alias} = ext;};
in
(lib.listToAttrs (
  map
    (x: {
      name = sanitizeName x;
      value = {
        src = "${source.officialSrc}/Extensions";
        filename = "${x}.js";
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
    map (x: mkExtAlias x.filename x) [
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
// (mkExtAlias "featureShuffle.js" featureShuffle)
// (mkExtAlias "playlistIcons.js" playlistIcons)
// (mkExtAlias "powerBar.js" powerBar)
// (mkExtAlias "groupSession.js" groupSession)
