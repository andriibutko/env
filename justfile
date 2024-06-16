help:
    just --list

hm command='switch' target='.':
    home-manager {{command}} --flake {{target}}

[macos]
darwin command='switch' target='.':
    nix run nix-darwin -- {{command}} --flake {{target}}

update:
    nix flake update
