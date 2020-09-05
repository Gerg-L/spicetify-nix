#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-prefetch-github

rm themes-src.nix
nix-prefetch-github --nix --rev master morpheusthewhite spicetify-themes > themes-src.nix