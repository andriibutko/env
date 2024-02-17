#!/bin/bash


nix build --impure \
        ./#darwinConfigurations.andriib.system
      result/sw/bin/darwin-rebuild switch \
        --impure \
        --flake ./#andriib

# TODO: Add yabai to sudoers
echo "$(whoami) ALL=(root) NOPASSWD: sha256:$(shasum -a 256 $(which yabai) | cut -d " " -f 1) $(which yabai) --load-sa" | sudo tee /private/etc/sudoers.d/yabai
