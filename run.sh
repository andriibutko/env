nix build --impure \
        ./#darwinConfigurations.andriib.system
      result/sw/bin/darwin-rebuild switch \
        --impure \
        --flake ./#andriib