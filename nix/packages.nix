{ pkgs, lib, stdenv, ... }:

with pkgs;
[
  coreutils
  git
  git-filter-repo
  git-lfs
  home-manager
  killall
  kubectl
  openssh
  openssl
  sqlite
  gh
] ++ lib.optionals stdenv.isDarwin [

] ++ [
  # all things editor
  nixfmt-classic
  nixpkgs-fmt
  shellcheck
]