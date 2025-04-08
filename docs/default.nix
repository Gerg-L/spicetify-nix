{
  self,
  version,
  pkgs,
  lib,
  stdenvNoCC,
  nixos-render-docs,
  nixosOptionsDoc,
}:
let
  evaluatedOptions =
    let
      scrubDerivations =
        namePrefix: pkgSet:
        builtins.mapAttrs (
          name: value:
          let
            wholeName = "${namePrefix}.${name}";
          in
          if builtins.isAttrs value then
            scrubDerivations wholeName value
            // lib.optionalAttrs (lib.isDerivation value) {
              inherit (value) drvPath;
              outPath = "\${${wholeName}}";
            }
          else
            value
        ) pkgSet;
    in
    (lib.evalModules {
      modules = [
        {
          _module = {
            check = false;
            args.pkgs = lib.mkForce (scrubDerivations "pkgs" pkgs);
          };
        }
        (import ../modules/common.nix self)
        ../modules/docs.nix
      ];
    }).options;

  filteredOptions = builtins.removeAttrs evaluatedOptions [ "_module" ];

  fixedOptions = nixosOptionsDoc {
    warningsAreErrors = false;
    options = filteredOptions;
    transformOptions =
      opt:
      opt
      // {
        declarations = map (
          decl:
          if lib.hasPrefix (toString ../.) (toString decl) then
            lib.pipe decl [
              toString
              (lib.removePrefix (toString ../.))
              (lib.removePrefix "/")
              (x: {
                url = "https://github.com/Gerg-L/spicetify-nix/blob/master/${x}";
                name = "<spicetify-nix/${x}>";
              })
            ]
          else if decl == "lib/modules.nix" then
            {
              url = "https://github.com/NixOS/nixpkgs/blob/master/${decl}";
              name = "<nixpkgs/lib/modules.nix>";
            }
          else
            decl
        ) opt.declarations;
      };
  };
in

stdenvNoCC.mkDerivation {
  name = "spicetify-nix-manual";
  src = ./src;
  nativeBuildInputs = [ nixos-render-docs ];
  buildPhase = ''
    mkdir -p $out

    substituteInPlace ./manual.md \
      --subst-var-by \
        VERSION \
        ${version}

    substituteInPlace ./options.md \
      --subst-var-by \
        OPTIONS_JSON \
        ${fixedOptions.optionsJSON}/share/doc/nixos/options.json

    nixos-render-docs manual html \
      --manpage-urls ${pkgs.path}/doc/manpage-urls.json \
      --revision ${version} \
      --toc-depth 2 \
      --section-toc-depth 1 \
      manual.md \
      $out/index.xhtml
  '';
}
