{ sources, lib }:
let
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
    src = "${sources.copyToClipboardSrc}/dist";
    name = "copytoclipboard.js";
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
  writeify = {
    src = "${sources.rxriSrc}/writeify";
    name = "writeify.js";
  };
  formatColors = {
    src = "${sources.rxriSrc}/formatColors";
    name = "formatColors.js";
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

  groupSession = {
    src = "${sources.groupSessionSrc}/src";
    name = "group-session.js";
  };

  adblockify = {
    src = "${sources.rxriSrc}/adblock";
    name = "adblock.js";
  };

  copyLyrics = {
    src = "${sources.aimarekinSrc}/_dist";
    name = "copy-lyrics.js";
  };
  playingSource = {
    src = "${sources.aimarekinSrc}/_dist";
    name = "playing-source.js";
  };
  randomBadToTheBoneRiff = {
    src = "${sources.aimarekinSrc}/_dist";
    name = "random-bad-to-the-bone-riff.js";
  };
  sectionMarker = {
    src = "${sources.aimarekinSrc}/_dist";
    name = "section-marker.js";
  };
  skipAfterTimestamp = {
    src = "${sources.aimarekinSrc}/_dist";
    name = "skip-after-timestamp.js";
  };

  beautifulLyrics = {
    src = "${sources.beautifulLyricsSrc}/Builds/Release";
    name = "beautiful-lyrics.mjs";
  };

  addToQueueTop = {
    src = "${sources.addToTopSrc}/addToQueueTop";
    name = "addToQueueTop.js";
  };

  sanitizeName =
    lib.replaceStrings
      [
        ".js"
        ".mjs"
        "+"
      ]
      [
        ""
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
{
  inherit adblockify;
}
// (lib.listToAttrs (
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
      writeify
      formatColors
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
      adblockify
      savePlaylists
      autoSkip
      fullScreen
      playNext
      volumePercentage
      oldSidebar
      addToQueueTop
    ]

  )
# aliases for weirdly named extension files
// (mkExtAlias "adblock" adblockify)
// (mkExtAlias "history.js" history)
// (mkExtAlias "volumeProfiles.js" volumeProfiles)
// (mkExtAlias "copyToClipboard.js" copyToClipboard)
// (mkExtAlias "songStats.js" songStats)
// (mkExtAlias "betterGenres.js" betterGenres)
// (mkExtAlias "featureShuffle.js" featureShuffle)
// (mkExtAlias "playlistIcons.js" playlistIcons)
// (mkExtAlias "powerBar.js" powerBar)
// (mkExtAlias "groupSession.js" groupSession)
// (mkExtAlias "copyLyrics.js" copyLyrics)
// (mkExtAlias "playingSource.js" playingSource)
// (mkExtAlias "randomBadToTheBoneRiff.js" randomBadToTheBoneRiff)
// (mkExtAlias "sectionMarker.js" sectionMarker)
// (mkExtAlias "skipAfterTimestamp.js" skipAfterTimestamp)
// (mkExtAlias "beautifulLyrics.js" beautifulLyrics)
