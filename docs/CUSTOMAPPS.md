# Custom Apps

## Using unpackaged customApps
```nix
programs.spicetify.enabledCustomApps= [
  ({
      # The source of the customApp
      # make sure you're using the correct branch
      # It could also be a sub-directory of the repo
      src = pkgs.fetchFromGitHub {
        owner = "";
        repo = "";
        rev = "";
        hash = "";
      };
      # The actual file name of the customApp usually ends with .js
      name = "";
  })
];
```

Almost all customApp PR's will be merged quickly
view the git history of /pkgs/apps.nix for PR examples


## Official Apps

### newReleases
Add a page showing new releases from artists you follow.

### reddit
Add a page showing popular music on certain music subreddits.

### lyricsPlus
Add a page with pretty scrolling lyrics.

### marketplace
Add a page where you can browse extensions, themes, apps, and snippets. Using the marketplace does not work with this flake, however it is still here in order to allow for browsing.

## Community Apps

### localFiles
Add a shortcut to see just your local files.

### nameThatTune
Heardle.app for spicetify. [Source](https://github.com/theRealPadster/name-that-tune)

### ncsVisualizer
NCS-style visualizer for Spicetify [Source](https://github.com/Konsl/spicetify-ncs-visualizer)

### historyInSidebar 
Adds a shortcut for the "Recently Played" screen to the sidebar. [Source](https://github.com/Bergbok/Spicetify-Creations)

### betterLibrary 
Bring back the centered library. [Source](https://github.com/Sowgro/betterLibrary)
