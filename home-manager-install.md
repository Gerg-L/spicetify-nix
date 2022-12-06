# Home Manager

If your linux installation uses Systemd (Fedora, Ubuntu, and Manjaro all use
Systemd) then you can install the **nix** package manager and **home-manager**
in order to manage spicetify. First, to install nix for all users on your
system, run the following command and follow the interactive prompts:

```bash
sh <(curl -L https://nixos.org/nix/install) --daemon

```

More information on nix installation can be found at [https://nixos.org/download.html](https://nixos.org/download.html)
Then, **restart your terminal/shell** and run the following command to enter a
shell with home-manager and git installed. We'll be running the rest of these
commands from inside this new shell. Type ``exit`` to leave it, if you need.

```bash
nix-shell -p home-manager git
```

Next, run the following commands to make a new home manager configuration for
spicetify in your current directory.

```bash
mkdir ~/home-manager-config && cd ~/home-manager-config
nix flake init --template github:the-argus/spicetify-nix --extra-experimental-features nix-command --extra-experimental-features flakes
sed "0,/unknown_username/{s/unknown_username/$(whoami)/}" -i flake.nix
sed "0,/unknown_hostname/{s/unknown_hostname/$(hostname)/}" -i flake.nix
git init --initial-branch=main
git add .
home-manager switch --flake . --extra-experimental-features nix-command --extra-experimental-features flakes
```

The spotify that's in your path (or the new spotify that appeared in your app
launchers) should now be a spiced version of spotify, complete with dribbblish
and some custom apps and extensions. Run ``spotify & disown`` to launch it, or
edit the ``spicetify.nix`` file to customize it. If you have any problems, also
check out the ``README.md`` file.
