{
  fetchgit,
  fetchzip,
  fetchFromGitHub,
  ...
}: {
  officialThemes = fetchgit {
    url = "https://github.com/spicetify/spicetify-themes";
    rev = "eb6b818368d9c01ef92522623b37aa29200d0bc0";
    sha256 = "1qrcvbxb0pmx0g8kzbb8yp20fdhf457jqdyfzs7nbdz3wr5w3wj3";
  };

  officialSrc = fetchgit {
    url = "https://github.com/spicetify/spicetify-cli";
    rev = "4b1fda2198fc61eb0b9a5fe30f3585dd47a02c16";
    sha256 = "131irkdlbm2d1gf4ngj1zm0cqm1c44axd0wkzzh9fc1dhcdzqigw";
  };

  catppuccinSrc = fetchgit {
    url = "https://github.com/catppuccin/spicetify";
    rev = "e883d8607054acbc9630e6695c93d5a803d42d7a";
    sha256 = "15j7vx0x2xjzkg23llbgnch1kyzp21285qcjkc72923q4by1fdk6";
  };

  spotifyNoPremiumSrc = fetchgit {
    url = "https://github.com/Daksh777/SpotifyNoPremium";
    rev = "a60480c817ce7291e70baf4cfc6a03b187205d2b";
    sha256 = "1rls5z468yk2q67xff9whg0gywa6mpxrkx60jmcgc0nx91cbvhq8";
  };

  comfySrc = fetchgit {
    url = "https://github.com/Comfy-Themes/Spicetify";
    rev = "b1a978d01ff446c0811e25c644c22d87d321509a";
    sha256 = "1j6vf0a2rb5il84vf1p91jjpc64ayczi2rziinc9qrdrwy43lgcr";
  };

  fluentSrc = fetchgit {
    url = "https://github.com/williamckha/spicetify-fluent";
    rev = "47c13bfa2983643a14229c5ecbb88d5001c91c6b";
    sha256 = "0pcx9wshrx0hp3rcjrhi7676baskp8r10bcahp6nr105s42d8x5z";
  };

  defaultDynamicSrc = fetchgit {
    url = "https://github.com/JulienMaille/spicetify-dynamic-theme";
    rev = "c9b70479a5445c09fadb575d2d5cf940b871ff4d";
    sha256 = "0k02yhzawpa9m5ck07v4j4brcnm7vxcp4bzfiwskh5a9i5xr4gkj";
  };

  retroBlurSrc = fetchgit {
    url = "https://github.com/Motschen/Retroblur";
    rev = "ff9bb863f8922a914269f973d9d0e0f9f2af8961";
    sha256 = "1c4c0wz0kn2n8pvzhxrkc3j80afcwvs312ai25fm04abgzyq1isk";
  };

  omniSrc = fetchgit {
    url = "https://github.com/getomni/spicetify";
    rev = "1c8cbf99cdea93f3a0e8297ddfb681e58551d51d";
    sha256 = "0s9avj0gq206hcj8qri025avv12pmmlswyffkxq6s2y2mi9wp0h7";
  };

  bloomSrc = fetchgit {
    url = "https://github.com/nimsandu/spicetify-bloom";
    rev = "ef1bb7e5af301540c76c68966ab0ebea0aaaa41b";
    sha256 = "1liidc5q3i4y97nnsrirk6s7kavprixdv6srhchsi1gz0b9ksv5a";
  };

  orchisSrc = fetchgit {
    url = "https://github.com/canbeardig/Spicetify-Orchis-Colours-v2";
    rev = "5bf3fcf0696514dcf3e95f4ae3fd00261ccc5dcc";
    sha256 = "1fzmxgjb3l6qn6a7zc621pqhh5m5xzjj1wqplk4rwnrrb1d3digm";
  };

  draculaSrc = fetchgit {
    url = "https://github.com/Darkempire78/Dracula-Spicetify";
    rev = "97bf149e7afbe408509862591a57f1d8e2dfc5d7";
    sha256 = "0l7la5hmhzfzf0n6lk3zxc4bc9f2h2dcwx02r6yqnrnkkkzh0b91";
  };

  nordSrc = fetchgit {
    url = "https://github.com/Tetrax-10/Nord-Spotify";
    rev = "b01394ecd7acd2deb25e9897a24cd97e282677c8";
    sha256 = "0yniia7rnjq8n1br9bazkyy0c7537kgyiypgdr4h07hjmpq4xyri";
  };

  dakshExtensions = fetchFromGitHub {
    owner = "daksh2k";
    repo = "Spicetify-stuff";
    rev = "67245d949a07e568581a76bd6197f163e334b54c";
    sha256 = "sha256-AfbYxjAuSWo6Oai3vkvG3LG9R09Fwfr0QU4nbPrawMI=";
  };

  hidePodcastsSrc = fetchgit {
    url = "https://github.com/theRealPadster/spicetify-hide-podcasts";
    rev = "a1fb7dc83d1452de259374c50344c0afbd613da3";
    sha256 = "1bfzsnwgddm7x826pykzjjv88s186c1l21ss7qjkb6hg0ny5dij4";
  };

  historySrc = fetchgit {
    url = "https://github.com/einzigartigerName/spicetify-history";
    rev = "577e34f364127f18d917d2fe2e8c8f2a1af9f6ae";
    sha256 = "0fv5fb6k9zc446a1lznhmd68m47sil5pqabv4dmrqk6cvfhba49r";
  };

  genreSrc = fetchFromGitHub {
    owner = "Shinyhero36";
    repo = "Spicetify-Genre";
    rev = "f2cb950a7e27cce3bfd4168141b5c5e55552df5a";
    sha256 = "sha256-R7D6oiSZviZQiMo6GSe4phQKfUmLNToXkyv6F4JXf3M=";
  };

  lastfmSrc = fetchgit {
    url = "https://github.com/LucasBares/spicetify-last-fm";
    rev = "088bc45c02d116ef4f614a3f7b9aa056df418876";
    sha256 = "0s4dj7r6yk8dqqasi3l0bipydpxm0pyjdnzjwhv7zmqn18arqwb8";
  };

  localFilesSrc = fetchgit {
    url = "https://github.com/hroland/spicetify-show-local-files/";
    rev = "1bfd2fc80385b21ed6dd207b00a371065e53042e";
    sha256 = "01gy16b69glqcalz1wm8kr5wsh94i419qx4nfmsavm4rcvcr3qlx";
  };

  autoVolumeSrc = fetchFromGitHub {
    owner = "amanharwara";
    repo = "spicetify-autoVolume";
    rev = "d7f7962724b567a8409ef2898602f2c57abddf5a";
    sha256 = "1pnya2j336f847h3vgiprdys4pl0i61ivbii1wyb7yx3wscq7ass";
  };

  customAppsExtensionsSrc = fetchgit {
    url = "https://github.com/3raxton/spicetify-custom-apps-and-extensions";
    rev = "0f5e79fe43abf57f714d7d00bd288870d5b6f718";
    sha256 = "1kjzaczp9p88jkf9jxkh3wrdydz9vhfljh6yaywzqsa2qz7zycp3";
  };

  spotifyCanvasSrc = fetchgit {
    url = "https://github.com/itsmeow/Spicetify-Canvas";
    rev = "7e8a384524b3ae28a2fc510e705d0d9437365716";
    sha256 = "1jqm2l4pl03xrkvrw2h1rvx3kbabsh1crd3nxz15d8j524cbdxa2";
  };

  charlieS1103Src = fetchFromGitHub {
    owner = "CharlieS1103";
    repo = "spicetify-extensions";
    rev = "edaec2f43c7fcf61ca30fa7eff500cfd70aa8e6f";
    sha256 = "sha256-tbgU7Rn8Ek6c0h+3Cxi7o3rxd2ymXprobtSX8cmEXbY=";
  };

  huhExtensionsSrc = fetchgit {
    url = "https://github.com/huhridge/huh-spicetify-extensions";
    rev = "dbfab3d4f00dd6e9228451b0b9d693397043f25f";
    sha256 = "0vsjp6dglir5vg824py7bbc559wfn1fcac3iwf8qpfmli4fswjpd";
  };

  playlistIconsSrc = fetchgit {
    url = "https://github.com/jeroentvb/spicetify-playlist-icons";
    rev = "9e3fd0dc9697af3105dfa5daff274a9ca781f8df";
    sha256 = "13if6b5q358xqk42cp6cby4c4ajzzxyra7b3j2m3q4ggdv3i3znq";
  };

  tetraxSrc = fetchgit {
    url = "https://github.com/Tetrax-10/Spicetify-Extensions";
    rev = "e4961f376eafa03b5aed3cc53478950ff52ba7d9";
    sha256 = "0mh9bq8glrlj0b1kc3lgkfwrfz9w0230911fv73s67ylmkbrvwzf";
  };

  powerBarSrc = fetchgit {
    url = "https://github.com/jeroentvb/spicetify-power-bar";
    rev = "7fe7b04334ca3258dbac855e4287617091efe9dd";
    sha256 = "05argdskjqal3rw70aapvd1g78yx8rga9lkddlf9a9s4i7jjl73a";
  };

  groupSessionSrc = fetchFromGitHub {
    owner = "timll";
    repo = "spotify-group-session";
    rev = "a9fa45da69495137b2f7272f61ff8d1a457aef5b";
    sha256 = "sha256-YTbnNLzPc0iMJZfH3QwSEX/gpAqIlchmbsULjM8musA=";
  };

  startPageSrc = fetchgit {
    url = "https://github.com/Resxt/startup-page";
    rev = "cca2b29e690dad4d8b89f0ba994b2f9a714f4e6a";
    sha256 = "1qqar6lcq1djbiwgsjd7sd5r8061fkwfy92yfvh3b7i9q939djf5";
  };

  marketplaceSrc = fetchzip {
    url = "https://github.com/spicetify/spicetify-marketplace/releases/download/v0.7.1/spicetify-marketplace-v0.7.1.zip";
    sha256 = "sha256-oTryiBkldW7RPjlJ9gw00XJi7QhwtUAueFt24Fh3NTo=";
  };

  nameThatTuneSrc = fetchgit {
    url = "https://github.com/theRealPadster/name-that-tune";
    rev = "46de6b5d39442a52c13b8ed9c9545d7fe8a6cb0b";
    sha256 = "1pgn7qg7msnmpclfm2l03x9fhldyn3jvgav863s203c9bl0g9i68";
  };
}
