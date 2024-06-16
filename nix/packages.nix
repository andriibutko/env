{ pkgs, lib, stdenv, ... }:

with pkgs;
[
  coreutils
  fish
  git
  git-filter-repo
  git-lfs
  home-manager
  jq
  killall
  kubectl
  openssh
  openssl
  sqlite
  unzip
  wget
  gh
] ++ lib.optionals stdenv.isDarwin [

] ++ [
  # all things editor
  (aspellWithDicts (dicts: with dicts; [ en en-computers en-science ]))
  nixfmt
  nixpkgs-fmt
  shellcheck
]