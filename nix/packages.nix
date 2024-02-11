{ pkgs, lib, stdenv, ... }:

with pkgs;
[
  coreutils
  fish
  git
  git-filter-repo
  git-lfs
  gnugrep
  gnumake
  gnupg
  gnuplot
  gnused
  gnutar
  home-manager
  jq
  killall
  kubectl
  openssh
  openssl
  sqlite
  unzip
  wget
] ++ lib.optionals stdenv.isDarwin [

] ++ [
  # all things editor
  (aspellWithDicts (dicts: with dicts; [ en en-computers en-science ]))
  languagetool
  nixfmt
  nixpkgs-fmt
  shellcheck
] ++ [
  # all things node :fear:
  nodePackages.npm
  nodePackages.pnpm
  nodePackages.typescript
  nodePackages.typescript-language-server
  nodePackages.webpack
  nodejs
  yarn
] ++ [
  # fonts
  font-awesome_4
  fontconfig
  # liberation_ttf
  mplus-outline-fonts.githubRelease
  source-code-pro
  source-sans-pro
  source-serif-pro
  roboto-mono
]