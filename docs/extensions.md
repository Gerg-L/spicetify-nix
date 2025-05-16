---
title: Extensions
---
# {{ $frontmatter.title }}

## Using unpackaged extensions

```nix
programs.spicetify.enabledExtensions = [
  ({
      # The source of the extension
      # make sure you're using the correct branch
      # It could also be a sub-directory of the repo
      src = pkgs.fetchFromGitHub {
        owner = "";
        repo = "";
        rev = "";
        hash = "";
      };
      # The actual file name of the extension usually ends with .js
      name = "";
  })
];
```

Almost all extension PR's will be merged quickly view the git history of
/pkgs/extensions.nix for PR examples

## Official Extensions

### autoSkipExplicit

Christian spotify!

### autoSkipVideo

Video playback (ads and stuff) causes problems in some regions where the videos
can't be played. Just skip them with this extension.

### bookmark

Store and browse pages for looking at later.

### fullAppDisplay

Shows the song cover, title, and artist in fullscreen.

### keyboardShortcut

Vimium-like navigation of spotify. See keyboard shortcuts
[here.](https://spicetify.app/docs/advanced-usage/extensions#keyboard-shortcut)

### loopyLoop

Specify a portion of track to loop over.

### popupLyrics

Open a popup window with the current song's lyrics scrolling across it.

### shuffle

Shuffle properly, using Fisher-Yates with zero bias.

### trashbin

Throw artists or songs in the trash, and permanently skip them.

### webnowplaying

Only useful to windows/rainmeter users, I think.
[Reference](https://spicetify.app/docs/advanced-usage/extensions#web-now-playing)

## Community Extensions

### groupSession

Allows you to create a link to share with your friends to listen along with you.

### powerBar

Spotlight-like search bar for spotify.

### seekSong

Allows for youtube-like seeking with keyboard shortcuts.

### skipOrPlayLikedSongs

Set spotify to automatically skip liked songs, or to only play liked songs.

### playlistIcons

Give your playlists icons in the left sidebar.

### fullAlbumDate

Display the day and month of an album's release, as well as the year.

### fullAppDisplayMod

Same as fullAppDisplay, but with slight offset, and scrolling lyrics if using
the lyrics-plus customapp.

### goToSong

Adds an option to the profile menu to go to the currently playing song or
playlist.

### listPlaylistsWithSong

Adds an option to the context menu for songs to show all of your account's
playlists which contain that song.

### playlistIntersection

Compare two playlists, and create a new playlist containing their common songs,
or only the songs unique to one playlist.

### skipStats

Track your skips.

### phraseToPlaylist

Given a phrase, this extension will make a playlist containing a series of songs
which make up that phrase.

### wikify

Show an artist's wikipedia entry.

### writeify

Take notes on songs.

### formatColors

Convert colors defined in root to color.ini format.

### featureShuffle

Create a playlist based off another playlist's audio features.

### oldSidebar

Go back to the old sidebar.

### songStats

Show a song's stats, like dancability, tempo, and key.

### autoVolume

Automatically adjust volume over long periods of time, to reduce ear strain.

### showQueueDuration

Show the total length of all songs currently queued.

### copyToClipboard

Adds an option in the context menu to copy a song's name to your clipboard.

### volumeProfiles

Edit and save settings related to volume to different "profiles."

### history

Adds a page that shows your listening history.

### betterGenres

See what genres the current song is.

### lastfm

Integration with last.fm. Login to show your listening stats for a song, and get
its last.fm link.

### hidePodcasts

Remove everything from the spotify UI relating to podcasts.

### adblock

Remove ads.

### savePlaylists

More than just just following a playlist, this extension allows you to also
create a duplicate of the playlist in your own library.

### autoSkip

Automatically skip certain songs by category, such as remixes, or christmas
songs.

### fullScreen

Similar to fullAppDisplay.

### playNext

Add track to the _top_ of the queue.

### volumePercentage

Adds a percentage number next to the volume adjustment slider, and allows for
more fine control of volume.

### copyLyrics

Copy the lyrics of your song directly from the "Show Lyrics" view. Click and
drag your mouse accross the lyrics, then release to copy them into your
clipboard.

### playingSource

See the context of where you're playing from, and jump to it.

### randomBadToTheBoneRiff

Hell yeah brother... Randomly plays the Bad to the Bone riff 💀

### sectionMarker

See a song's highlighted sections straight from your playbar.

### skipAfterTimestamp

Automatically skip tracks after they reach a timestamp.

### beautifulLyrics

Beautiful Lyrics provides Lyrics to EVERYONE for FREE. Beautiful Lyrics supports
Karaoke, Line, and Statically synced lyrics with additional features like
Background Vocals and Side Vocals.

### addToQueueTop

Adds the ability to add a track | playlist to the top of your Queue, instantly
playing it after the currently playing track ends.

### oneko

cat follow mouse (real). A fork of oneko.js modified for Spicetify.

### starRatings

Rate your music out of 5 stars

### queueTime

Simply displays the time remaining in the current queue.

### simpleBeautifulLyrics

Enhance your full-screen song lyrics experience with this simple theme for
Spotify lyrics page.

### allOfArtist

Create a playlist with all songs of an artist 

### oldLikeButton

Add the Old Like Button in tracklists 

### oldCoverClick

Restore the old behaviour of clicking on the album cover in the playback bar

### bestMoment

Let you select and listen to a specific segment of the track
