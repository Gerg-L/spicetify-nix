{
  fetchzip,
  fetchgit,
  fetchurl,
}:
let

  data = builtins.fromJSON (builtins.readFile ./sources.json);

  mkSource =
    spec:
    assert spec ? type;
    let
      path =
        if spec.type == "Git" then
          mkGitSource spec
        else if spec.type == "GitRelease" then
          mkGitSource spec
        else if spec.type == "PyPi" then
          mkPyPiSource spec
        else if spec.type == "Channel" then
          mkChannelSource spec
        else
          throw "Unknown source type ${spec.type}";
    in
    spec // { outPath = path; };

  mkGitSource =
    {
      repository,
      revision,
      url ? null,
      hash,
      ...
    }:
    assert repository ? type;
    # At the moment, either it is a plain git repository (which has an url), or it is a GitHub/GitLab repository
    # In the latter case, there we will always be an url to the tarball
    if url != null then
      (fetchzip {
        inherit url;
        sha256 = hash;
        extension = "tar";
      })
    else
      assert repository.type == "Git";
      fetchgit {
        inherit (repository) url;
        rev = revision;
      };

  mkPyPiSource =
    { url, hash, ... }:
    fetchurl {
      inherit url;
      sha256 = hash;
    };

  mkChannelSource =
    { url, hash, ... }:
    fetchzip {
      inherit url;
      sha256 = hash;
      extension = "tar";
    };
in
builtins.mapAttrs (_: mkSource) data.pins
