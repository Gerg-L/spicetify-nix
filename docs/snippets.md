---
title: Snippets
---
# {{ $frontmatter.title }}

Snippets are just strings, so you can put whatever css you want into `enabledSnippets`.

```nix
enabledSnippets = [
  ''
    Some long css string
  ''
];
```

Or use any of the generated ones:

Currently the creation of snippets is done using the spicetify marketplace snippets.json file at <https://github.com/spicetify/marketplace/blob/main/resources/snippets.json>

The name of the snippets are the file name of the `previews` field in `camelCase`.

For example:

```json
{
  "title": "Remove Playlist Album Cover",
  "description": "Remove the album cover from the playlist banner",
  "code": ".main-entityHeader-imageContainer.main-entityHeader-imageContainerNew { display: none; }",
  "preview": "resources/assets/snippets/Remove-Playlist-Cover.png"
}
```

is named `removePlaylistCover`

You can view all available snippets using:

```bash
nix eval --impure --json --expr 'builtins.attrNames ((builtins.getFlake "github:Gerg-L/spicetify-nix").legacyPackages.x86_64-linux.snippets)'
```
