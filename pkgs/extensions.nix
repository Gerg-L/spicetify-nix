{ sources, lib }:

let
  ##3
  neverAutoplay = {
    src = "${sources."39digits"}";
    name = "neverAutoplay.js";
  };
  ##4
  romajaLyrics = {
    src = "${sources."41pha1"}/romaja-lyrics";
    name = "romaja_lyrics.js";
  };
  romajiLyrics = {
    src = "${sources."41pha1"}/romaji-lyrics";
    name = "romaji_lyrics.js";
  };
  ##A
  quickAddToPlaylist = {
    src = "${sources."adufr"}/quick-add-to-playlist/dist";
    name = "quick-add-to-playlist.js";
  };
  quickAddToQueue = {
    src = "${sources."adufr"}/quick-add-to-queue/dist";
    name = "quick-add-to-queue.js";
  };

  hideImages = {
    src = "${sources."adventuretc"}";
    name = "HideImages.js";
  };

  detailsExtractor = {
    src = "${sources."afonsojramos"}/spicetify";
    name = "extractor.js";
  };

  libplayer = {
    src = "${sources."Afterlifepro"}/dist";
    name = "libplayer.js";
  };

  copyLyrics = {
    src = "${sources.Aimarekin}/_dist";
    name = "copy-lyrics.js";
  };
  playWithoutContext = {
    src = "${sources.Aimarekin}/_dist";
    name = "play-without-context.js";
  };
  playingSource = {
    src = "${sources.Aimarekin}/_dist";
    name = "playing-source.js";
  };
  randomBadToTheBoneRiff = {
    src = "${sources.Aimarekin}/_dist";
    name = "random-bad-to-the-bone-riff.js";
  };
  sectionMarker = {
    src = "${sources.Aimarekin}/_dist";
    name = "section-marker.js";
  };
  skipAfterTimestamp = {
    src = "${sources.Aimarekin}/_dist";
    name = "skip-after-timestamp.js";
  };

  luckyLP = {
    src = "${sources.Akasiek}/dist";
    name = "LuckyLP.js";
  };

  vinylCover = {
    src = "${sources.AkselVdev}/Extensions";
    name = "vinylcover.js";
  };

  friendLikes = {
    src = "${sources.aloverso}/extension";
    name = "friendlikes.js";
  };

  collapsingLibary = {
    src = "${sources.Alpacinator}";
    name = "collapsing-library.js";
  };

  autoVolume = {
    src = "${sources.amanharwara}";
    name = "autoVolume.js";
  };

  showQueueDuration = {
    src = "${sources.andrsdt}";
    name = "showQueueDuration.js";
  };

  alwaysPrivateSession = {
    src = "${sources.api-haus}/dist";
    name = "spicetify-antisocial.js";
  };

  aotyScores = {
    src = "${sources.ashercs}";
    name = "aoty.js";
  };

  volumePlus = {
    src = "${sources.Aspecky}/volume-plus/dist";
    name = "volume-plus.js";
  };
  whereNowPlaying = {
    src = "${sources.Aspecky}/where-now-playing/dist";
    name = "where-now-playing.js";
  };

  enhancePlus = {
    src = "${sources.Aztup}/dist";
    name = "enhancePlus.js";
  };
  ##B
  convenientRepeat = {
    src = "${sources.bc9123}";
    name = "convenient-repeat.js";
  };

  trackTrim = {
    src = "${sources.BenWithJamInn}/release";
    name = "track-trim.js";
  };

  autoSkipTracksByDuration = {
    src = "${sources.Bergbok-extensions}";
    name = "auto-skip-tracks-by-duration.js";
  };

  anonymizedRadios = {
    src = "${sources.BitesizedLion}";
    name = "AnonymizedRadios.js";
  };

  catJamSynced = {
    src = "${sources.BlafKing}/marketplace";
    name = "cat-jam.js";
  };

  partSelector = {
    src = "${sources.bleizix}";
    name = "part_selector.js";
  };

  privateSession = {
    src = "${sources.bojanraic}/private-session/dist";
    name = "private-session.5240426fe7403c4cf9cd.js";
   # name = (builtins.head (builtins.filter (file: builtins.match "private-session.*\\.js" file.name != null) (builtins.readDir privateSession.src))); #- not working
  };
  sideHide = {
    src = "${sources.bojanraic}/side-hide/dist";
    name = "side-hide.03531a9075bc8ae10779.js";
    # name = (builtins.head (builtins.filter (file: builtins.match "side-hide.*\\.js" file.name != null) (builtins.readDir sideHide.src))); #- not working
  };
  ytVideo = {
    src = "${sources.bojanraic}/yt-video/dist";
    name = "yt-video.e4314fca1abeffbf25aa.js";
    # name = (builtins.head (builtins.filter (file: builtins.match "yt-video.*\\.js" file.name != null) (builtins.readDir ytVideo.src))); #- not working
  };

  starRatings = {
    src = "${sources.brimell}/dist";
    name = "star-ratings.js";
  };
  ##C
  smoothPlaybar = {
    src = "${sources.cAttte}";
    name = "smooth-playbar.js";
  };

  songViews = {
    src = "${sources.ch4xm}";
    name = "song-views.js";
  };
  ##D
  autoSkip = {
    src = "${sources.daksh2k}/Extensions/auto-skip/dist";
    name = "autoSkip.js";
  };
  fullScreen = {
    src = "${sources.daksh2k}/Extensions/full-screen/dist";
    name = "fullScreen.js";
  };
  playNext = {
    src = "${sources.daksh2k}/Extensions";
    name = "playNext.js";
  };
  savePlaylists = {
    src = "${sources.daksh2k}/Extensions";
    name = "savePlaylists.js";
  };
  volumePercentagedaksh2k = {
    src = "${sources.daksh2k}/Extensions";
    name = "volumePercentage.js";
  };

  customControls = {
    src = "${sources.darkthemer}/customControls";
    name = "customControls.js";
  };

  requestPlus = {
    src = "${sources.DarkWolfie-YouTube}";
    name = "requestplus.js";
  };

  randomishPlaylistMaker = {
    src = "${sources.Dotsgo_1}";
    name = "randomishPlaylistMaker.js";
  };
  recentTrackPlaylist = {
    src = "${sources.Dotsgo_2}";
    name = "recentTrackPlaylist.js";
  };
  removeRecentlyPlayedTracks = {
    src = "${sources.Dotsgo_3}";
    name = "removeRecentlyPlayedTracks.js";
  };

  furiganaLyrics = {
    src = "${sources.duffey}/dist";
    name = "spicetify-furigana-lyrics.js";
  };

  lyricsGlow = {
    src = "${sources.dupitydumb}/Spicetify";
    name = "content.js";
  };
  ##E
  playbarDynamic = {
    src = "${sources.Eeu2005}/dist";
    name = "playbar-dynamic.js";
  };
  ##F
  upcomingSong = {
    src = "${sources.fl3xm3ist3r}/upcomingSong";
    name = "upcomingSong.js";
  };

  cssEditor = {
    src = "${sources.FlafyDev_1}/dist";
    name = "css-editor.js";
  };
  listenTogether = {
    src = "${sources.FlafyDev_2}/compiled";
    name = "listenTogether.js";
  };
  ##G
  whoAdded = {
    src = "${sources.GentlyTech}/WhoAdded";
    name = "who-added.js";
  };

  skipOrPlayLikedSongs = {
    src = "${sources.GiorgosAthanasopoulos}";
    name = "skipOrPlayLikedSongs.js";
  };

  hotCues = {
    src = "${sources.gray-matter}/dist";
    name = "hot-cues.js";
  };
  ##H
  vinylOverlay = {
    src = "${sources.HackedApp}";
    name = "vinyl.js";
  };

  shareOnTwitter = {
    src = "${sources.hideki0403}/dist";
    name = "share-on-twitter.js";
  };

  sortPlay = {
    src = "${sources.hoeci}";
    name = "sort-play.js";
  };

  displayFullAlbumDate = {
    src = "${sources.huhridge}/fullAlbumDate";
    name = "fullAlbumDate.js";
  };
  fullAppDisplayModifier = {
    src = "${sources.huhridge}/fullAppDisplayModified";
    name = "fullAppDisplayMod.js";
  };
  goToSong = {
    src = "${sources.huhridge}/goToSong";
    name = "goToSong.js";
  };
  listPlaylistsWithSong = {
    src = "${sources.huhridge}/listPlaylistsWithSong";
    name = "listPlaylistsWithSong.js";
  };
  playlistIntersection = {
    src = "${sources.huhridge}/playlistIntersection";
    name = "playlistIntersection.js";
  };
  skipStats = {
    src = "${sources.huhridge}/skipStats";
    name = "skipStats.js";
  };
  ##I
  smoothScrolling = {
    src = "${sources.iHelops}/dist";
    name = "smooth-scrolling.js";
  };

  collapseSidebar = {
    src = "${sources.Isbo2000}";
    name = "collapseSidebar.js";
  };
  ##J
  playlistIcons = {
    src = "${sources.jeroentvb-extensions_1}";
    name = "playlist-icons.js";
  };
  powerBar = {
    src = "${sources.jeroentvb-extensions_2}";
    name = "power-bar.js";
  };
  showGenre = {
    src = "${sources.jeroentvb-extensions_3}";
    name = "genre.js";
  };
  volumePercentagejeroentvb = {
    src = "${sources.jeroentvb-extensions_4}";
    name = "volumePercentage.js";
  };
  ##K
  simpleBeautifulLyrics = {
    src = "${sources.Kamiloo13}/extensions/simple-beautiful-lyrics/dist";
    name = "simple-beautiful-lyrics.js";
  };
  sleepTimerUpdated = {
    src = "${sources.Kamiloo13}/extensions/sleep-timer-updated/dist";
    name = "sleep-timer-updated.js";
  };

  colorOverWebSocket = {
    src = "${sources.kevin-256}/dist";
    name = "color-over-websocket.js";
  };

  contextSwitcher = {
    src = "${sources.Konsl-extensions}/context-switcher/dist";
    name = "context-switcher.js";
  };
  findDuplicates = {
    src = "${sources.Konsl-extensions}/find-duplicates/dist";
    name = "find-duplicates.js";
  };
  waveformPlaybackBar = {
    src = "${sources.Konsl-extensions}/playback-bar-waveform/dist";
    name = "playback-bar-waveform.js";
  };

  cacheCleaner = {
    src = "${sources.kyrie25_1}";
    name = "cacheCleaner.js";
  };
  oneko = {
    src = "${sources.kyrie25_2}";
    name = "oneko.js";
  };
  utilities = {
    src = "${sources.kyrie25_3}";
    name = "utilities.js";
  };
  ##L
  djInfo = {
    src = "${sources.L3-N0X}";
    name = "djinfo.js";
  };

  loopPodcasts = {
    src = "${sources.lightningik}/podcast-loop/dist";
    name = "podcast-loop.js";
  };

  whatsThatGenre = {
    src = "${sources.LucasOe}/dist";
    name = "whatsThatGenre.js";
  };
  ##M
  toggleAutoplay = {
    src = "${sources.Marcell-Puskas}";
    name = "autoplay-toggle.js";
  };

  oldLikeButton = {
    src = "${sources.Maskowh}";
    name = "oldLikeButton.js";
  };

  copyTrackTitles = {
    src = "${sources.mchubby}/dist";
    name = "copy-track-titles.js";
  };

  shareOnMisskey = {
    src = "${sources.Midra429}/dist";
    name = "share-on-misskey.js";
  };

  bestMoment = {
    src = "${sources.MLGRussianXP}/dist";
    name = "best-moment.js";
  };

  twitchSpotifi = {
    src = "${sources.MrPandir}/dist";
    name = "twitch-spotifi.js";
  };

  dynamicLightsHomeassistant = {
    src = "${sources.muckelba}/dist";
    name = "dynamic-lights-homeassistant.js";
  };

  weightedPlaylists = {
    src = "${sources.mwaterman29}";
    name = "weighted-playlists.js";
  };

  friendify = {
    src = "${sources.myanlll}/dist";
    name = "friendify.js";
  };
  ##N
  rewind = {
    src = "${sources.NickColley}";
    name = "index.js";
  };

  dancingRaccoon = {
    src = "${sources.NigelMarshal}/marketplace";
    name = "dancing-raccoon.js";
  };

  volumeProfiles = {
    src = "${sources.notPlancha}/dist";
    name = "volume-profiles.js";
  };

  raccoonSynced = {
    src = "${sources.Nuzair46}/dist";
    name = "raccoon-wheel.js";
  };
  ##O
  goveeDynamicLights = {
    src = "${sources.obvRedwolf}";
    name = "govee-dynamic-lights.js";
  };

  beautifulFullscreen = {
    src = "${sources.Oein}/dist";
    name = "beautiful-fullscreen.js";
  };

  gamepad = {
    src = "${sources.ohitstom}/gamepad";
    name = "gamepad.js";
  };
  immersiveView = {
    src = "${sources.ohitstom}/immersiveView";
    name = "immersiveView.js";
  };
  noControls = {
    src = "${sources.ohitstom}/noControls";
    name = "noControls.js";
  };
  npvAmbience = {
    src = "${sources.ohitstom}/npvAmbience";
    name = "npvAmbience.js";
  };
  pixelatedImages = {
    src = "${sources.ohitstom}/pixelatedImages";
    name = "pixelatedImages.js";
  };
  playbarClock = {
    src = "${sources.ohitstom}/playbarClock";
    name = "playbarClock.js";
  };
  quickQueue = {
    src = "${sources.ohitstom}/quickQueue";
    name = "quickQueue.js";
  };
  scannables = {
    src = "${sources.ohitstom}/scannables";
    name = "scannables.js";
  };
  sleepTimerohitstom = {
    src = "${sources.ohitstom}/sleepTimer";
    name = "sleepTimer.js";
  };
  spotifyBackup = {
    src = "${sources.ohitstom}/spotifyBackup";
    name = "spotifyBackup.js";
  };
  toggleDJ = {
    src = "${sources.ohitstom}/toggleDJ";
    name = "toggleDJ.js";
  };
  tracksToEdges = {
    src = "${sources.ohitstom}/tracksToEdges";
    name = "tracksToEdges.js";
  };
  volumePercentageohitstom = {
    src = "${sources.ohitstom}/volumePercentage";
    name = "volumePercentage.js";
  };

  playlistProxy = {
    src = "${sources.okanten}";
    name = "PlaylistProxy.js";
  };

  playbackAPI = {
    src = "${sources.Om-Thorat}/dist";
    name = "playbackapi.js";
  };
  ##P
  availabilityMap = {
    src = "${sources.Pithaya}/extensions/availability-map/dist";
    name = "availability-map.js";
  };
  extendedCopy = {
    src = "${sources.Pithaya}/extensions/extended-copy/dist";
    name = "extended-copy.js";
  };
  madeForYouShortcut = {
    src = "${sources.Pithaya}/extensions/made-for-you-shortcut/dist";
    name = "made-for-you-shortcut.js";
  };
  romajiConvert = {
    src = "${sources.Pithaya}/extensions/romaji-convert/dist";
    name = "romaji-convert.js";
  };

  allOfArtist = {
    src = "${sources.Pl4neta}";
    name = "allOfArtist.js";
  };

  moreNowPlayingInfo = {
    src = "${sources.Plueres}/more-now-playing-info";
    name = "test.js";
  };
  nowPlayingReleaseDate = {
    src = "${sources.Plueres}/now-playing-release-date";
    name = "NowPlayingReleaseDate.js";
  };
  trackTags = {
    src = "${sources.Plueres}/track-tags";
    name = "tags.js";
  };

  copyToClipboard = {
    src = "${sources.pnthach95}/dist";
    name = "copytoclipboard.js";
  };

  queueShuffler = {
    src = "${sources.podpah}/queueShuffler";
    name = "queueShuffler.js";
  };
  reloadPage = {
    src = "${sources.podpah}/reloadPage";
    name = "reloadPage.js";
  };

  controllifyPlugin = {
    src = "${sources.prochy-exe_1}/dist";
    name = "controllify-plugin.js";
  };
  odesly = {
    src = "${sources.prochy-exe_2}/dist";
    name = "odesly-spicetify.js";
  };
  ##Q
  playlistLabels = {
    src = "${sources.qixing-jk}/dist";
    name = "spicetify-playlist-labels.js";
  };
  ##R
  youtubeKeybinds = {
    src = "${sources.rastr1sr}";
    name = "youtubekeybinds.js";
  };

  discographyToPlaylist = {
    src = "${sources.Resxt}/discography-to-playlist/dist";
    name = "discography-to-playlist.js";
  };
  fullQueueClear = {
    src = "${sources.Resxt}/full-queue-clear/dist";
    name = "full-queue-clear.js";
  };
  removeUnplayableSongs = {
    src = "${sources.Resxt}/remove-unplayable-songs/dist";
    name = "remove-unplayable-songs.js";
  };
  skipSongPart = {
    src = "${sources.Resxt}/skip-song-part/dist";
    name = "skip-song-part.js";
  };
  startupPage = {
    src = "${sources.Resxt}/startup-page/dist";
    name = "startup-page.js";
  };

  romajin = {
    src = "${sources.Richie-Z}";
    name = "romajin.js";
  };

  autoPlay = {
    src = "${sources.Ruxery}";
    name = "autoplay.js";
  };

  adblockify = {
    src = "${sources.rxri}/adblock";
    name = "adblock.js";
  };
  featureShuffle = {
    src = "${sources.rxri}/featureshuffle";
    name = "featureshuffle.js";
  };
  formatColors = {
    src = "${sources.rxri}/formatColors";
    name = "formatColors.js";
  };
  oldSidebar = {
    src = "${sources.rxri}/old-sidebar";
    name = "oldSidebar.js";
  };
  phraseToPlaylist = {
    src = "${sources.rxri}/phraseToPlaylist";
    name = "phraseToPlaylist.js";
  };
  songStats = {
    src = "${sources.rxri}/songstats";
    name = "songstats.js";
  };
  wikify = {
    src = "${sources.rxri}/wikify";
    name = "wikify.js";
  };
  writeify = {
    src = "${sources.rxri}/writeify";
    name = "writeify.js";
  };
  ##S
  resumePlaylist = {
    src = "${sources.Samych02}/dist";
    name = "resume-playlist.js";
  };

  dailyMixUrlFixer = {
    src = "${sources.sanoojes-extensions}/mix-url-fixer";
    name = "mix-url-fixer.js";
  };
  libXReborn = {
    src = "${sources.sanoojes-extensions}/LibX-Reborn/remote";
    name = "LibX-Reborn.js";
  };

  alwaysPlayVideos = {
    src = "${sources.SBijpost}/marketplace";
    name = "always-play-videos.js";
  };

  ledFxColorSync = {
    src = "${sources.ShadowAya}/dist";
    name = "ledfx-color-sync.js";
  };

  noTrackingLinks = {
    src = "${sources.SIMULTAN}/Extensions";
    name = "noTrackingLinks.js";
  };

  addToQueueTop = {
    src = "${sources.Socketlike}/addToQueueTop";
    name = "addToQueueTop.js";
  };

  autoSkipExplicit = {
    src = "${sources.Spicetify-cli}/Extensions";
    name = "autoSkipExplicit.js";
  };
  autoSkipVideo = {
    src = "${sources.Spicetify-cli}/Extensions";
    name = "autoSkipVideo.js";
  };
  bookmark = {
    src = "${sources.Spicetify-cli}/Extensions";
    name = "bookmark.js";
  };
  fullAppDisplay = {
    src = "${sources.Spicetify-cli}/Extensions";
    name = "fullAppDisplay.js";
  };
  keyboardShortcut = {
    src = "${sources.Spicetify-cli}/Extensions";
    name = "keyboardShortcut.js";
  };
  loopyLoop = {
    src = "${sources.Spicetify-cli}/Extensions";
    name = "loopyLoop.js";
  };
  popupLyrics = {
    src = "${sources.Spicetify-cli}/Extensions";
    name = "popupLyrics.js";
  };
  shufflePlus = {
    src = "${sources.Spicetify-cli}/Extensions";
    name = "shuffle+.js";
  };
  trashbin = {
    src = "${sources.Spicetify-cli}/Extensions";
    name = "trashbin.js";
  };
  webnowplaying = {
    src = "${sources.Spicetify-cli}/Extensions";
    name = "webnowplaying.js";
  };

  beautifulLyricsSpikerko = {
   src = "${sources.Spikerko_1}/Builds/Release";
   name = "beautiful-lyrics.mjs";
  };
  spicyLyrics = {
    src = "${sources.Spikerko_2}/builds";
    name = "spicy-lyrics.mjs";
  };
  theBirdPingpongballizer = {
    src = "${sources.Spikerko_3}/dist";
    name = "the-bird-pingpongballizer.js";
  };

  seekOnScroll = {
    src = "${sources.SunsetTechuila}/dist";
    name = "seekonscroll.js";
  };
  beautifulLyricssurfbryce = {
    src = "${sources.surfbryce}/Builds/Release";
    name = "beautiful-lyrics.mjs";
  };

  copyPlaylistInfo = {
    src = "${sources.SyndiShanX-extensions}/copyPlaylistInfo";
    name = "copyPlaylistInfo.js";
  };

  legacyLook = {
    src = "${sources.szymonszewcjr}";
    name = "legacyLook.js";
  };
  ##T
  lastfmStats = {
    src = "${sources.Taeko-ar}/src";
    name = "lastfm.js";
  };

  playRandom = {
    src = "${sources.TechShivvy}/play-random";
    name = "playRandom.mjs";
  };
  spotispy = {
    src = "${sources.TechShivvy}/spotispy";
    name = "spotispy.js";
  };

  coverAmbience = {
    src = "${sources.Theblockbuster1}/CoverAmbience";
    name = "CoverAmbience.js";
  };
  queueTime = {
    src = "${sources.Theblockbuster1}/QueueTime";
    name = "QueueTime.js";
  };
  sleepTimerTheblockbuster1 = {
    src = "${sources.Theblockbuster1}/SleepTimer";
    name = "SleepTimer.js";
  };

  toggleFriendActivity = {
    src = "${sources.TheGeeKing}/toggleFriendActivity";
    name = "toggleFriendActivity.js";
  };
  toggleLyricsPlusFullscreen = {
    src = "${sources.TheGeeKing}/toggleLyricsPlusFullscreen";
    name = "toggleLyricsPlusFullscreen.js";
  };

  hidePodcasts = {
    src = "${sources.theRealPadster-extensions}";
    name = "hidePodcasts.js";
  };

  xcxcovers = {
    src = "${sources.thirtysomethings}";
    name = "xcxcovers.js";
  };

  seekSongKeybinds = {
    src = "${sources.tlozs}";
    name = "seekSongKeybinds.js";
  };

  pictureInPicture = {
    src = "${sources.T0RNATO}/dist";
    name = "picture-in-picture.js";
  };
  ##U
  removeFriendsActivityMenu = {
    src = "${sources.Undead34}/RemoveFriendsActivityMenu";
    name = "removeFriendsActivityMenu.js";
  };
  ##V
  autoSkipPattern = {
    src = "${sources.vbalien}/dist";
    name = "autoSkipPattern.js";
  };

  betterSpotifyGenres = {
    src = "${sources.Vexcited}";
    name = "spotifyGenres.js";
  };
  ##W
  oldCoverClick = {
    src = "${sources.WaddlesPlays}/oldCoverClick";
    name = "oldCoverClick.js";
  };
  ##X
  betterAOTYScores = {
    src = "${sources.x1yl}";
    name = "aoty.js";
  };
  ##Y
  homeWhereYouBelong = {
    src = "${sources.yodaluca23}/HomeWhereYouBelong";
    name = "HomeWhereYouBelong.js";
  };
  spicyTracer = {
    src = "${sources.yodaluca23}/SpicyTracer";
    name = "SpicyTracer.js";
  };
  ##Z

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
# append .js
//  lib.attrsets.mergeAttrsList (
    map (x: mkExtAlias x.name x) [
      neverAutoplay
      romajaLyrics
      romajiLyrics
      quickAddToPlaylist
      quickAddToQueue
      hideImages
      detailsExtractor
      libplayer
      copyLyrics
      playWithoutContext
      playingSource
      randomBadToTheBoneRiff
      sectionMarker
      skipAfterTimestamp
      luckyLP
      vinylCover
      friendLikes
      collapsingLibary
      autoVolume
      showQueueDuration
      alwaysPrivateSession
      aotyScores
      volumePlus
      whereNowPlaying
      enhancePlus
      convenientRepeat
      trackTrim
      autoSkipTracksByDuration
      anonymizedRadios
      catJamSynced
      partSelector
      privateSession
      sideHide
      ytVideo
      starRatings
      smoothPlaybar
      songViews
      autoSkip
      fullScreen
      playNext
      savePlaylists
      volumePercentagedaksh2k
      customControls
      requestPlus
      randomishPlaylistMaker
      recentTrackPlaylist
      removeRecentlyPlayedTracks
      furiganaLyrics
      lyricsGlow
      playbarDynamic
      upcomingSong
      cssEditor
      listenTogether
      whoAdded
      skipOrPlayLikedSongs
      hotCues
      vinylOverlay
      shareOnTwitter
      sortPlay
      displayFullAlbumDate
      fullAppDisplayModifier
      goToSong
      listPlaylistsWithSong
      playlistIntersection
      skipStats
      smoothScrolling
      collapseSidebar
      playlistIcons
      powerBar
      showGenre
      volumePercentagejeroentvb
      simpleBeautifulLyrics
      sleepTimerUpdated
      colorOverWebSocket
      contextSwitcher
      findDuplicates
      waveformPlaybackBar
      cacheCleaner
      oneko
      utilities
      djInfo
      loopPodcasts
      whatsThatGenre
      toggleAutoplay
      oldLikeButton
      copyTrackTitles
      shareOnMisskey
      bestMoment
      twitchSpotifi
      dynamicLightsHomeassistant
      weightedPlaylists
      friendify
      rewind
      dancingRaccoon
      volumeProfiles
      raccoonSynced
      goveeDynamicLights
      beautifulFullscreen
      gamepad
      immersiveView
      noControls
      npvAmbience
      pixelatedImages
      playbarClock
      quickQueue
      scannables
      sleepTimerohitstom
      spotifyBackup
      toggleDJ
      tracksToEdges
      volumePercentageohitstom
      playlistProxy
      playbackAPI
      availabilityMap
      extendedCopy
      madeForYouShortcut
      romajiConvert
      allOfArtist
      moreNowPlayingInfo
      nowPlayingReleaseDate
      trackTags
      copyToClipboard
      queueShuffler
      reloadPage
      controllifyPlugin
      odesly
      playlistLabels
      youtubeKeybinds
      discographyToPlaylist
      fullQueueClear
      removeUnplayableSongs
      skipSongPart
      startupPage
      romajin
      autoPlay
      adblockify
      featureShuffle
      formatColors
      oldSidebar
      phraseToPlaylist
      songStats
      wikify
      writeify
      resumePlaylist
      dailyMixUrlFixer
      libXReborn
      alwaysPlayVideos
      ledFxColorSync
      noTrackingLinks
      addToQueueTop
      autoSkipExplicit
      autoSkipVideo
      bookmark
      fullAppDisplay
      keyboardShortcut
      loopyLoop
      popupLyrics
      shufflePlus
      trashbin
      webnowplaying
      beautifulLyricsSpikerko
      spicyLyrics
      theBirdPingpongballizer
      seekOnScroll
      beautifulLyricssurfbryce
      copyPlaylistInfo
      legacyLook
      lastfmStats
      playRandom
      spotispy
      coverAmbience
      queueTime
      sleepTimerTheblockbuster1
      toggleFriendActivity
      toggleLyricsPlusFullscreen
      hidePodcasts
      xcxcovers
      seekSongKeybinds
      pictureInPicture
      removeFriendsActivityMenu
      autoSkipPattern
      betterSpotifyGenres
      oldCoverClick
      betterAOTYScores
      homeWhereYouBelong
      spicyTracer
    ]
  )
# aliases for weirdly named extension files
# // (mkExtAlias "beautifulLyrics.js" beautifulLyricsSpikerko)
# // (mkExtAlias "spicyLyrics.js" spicyLyrics)
# // (mkExtAlias "beautifulLyricssurfbryce.js" beautifulLyricssurfbryce)
# // (mkExtAlias "playRandom.js" playRandom)
#
# aliases for weirdly named extension files
// (mkExtAlias "adblock" adblockify)
// (mkExtAlias "volumeProfiles.js" volumeProfiles)
// (mkExtAlias "copyToClipboard.js" copyToClipboard)
// (mkExtAlias "songStats.js" songStats)
// (mkExtAlias "betterGenres.js" betterSpotifyGenres)
// (mkExtAlias "featureShuffle.js" featureShuffle)
// (mkExtAlias "playlistIcons.js" playlistIcons)
// (mkExtAlias "powerBar.js" powerBar)
// (mkExtAlias "copyLyrics.js" copyLyrics)
// (mkExtAlias "playingSource.js" playingSource)
// (mkExtAlias "randomBadToTheBoneRiff.js" randomBadToTheBoneRiff)
// (mkExtAlias "sectionMarker.js" sectionMarker)
// (mkExtAlias "skipAfterTimestamp.js" skipAfterTimestamp)
// (mkExtAlias "beautifulLyrics.js" beautifulLyricssurfbryce)
// (mkExtAlias "oneko.js" oneko)
// (mkExtAlias "starRatings.js" starRatings)
// (mkExtAlias "queueTime.js" queueTime)
// (mkExtAlias "simpleBeautifulLyrics.js" simpleBeautifulLyrics)
