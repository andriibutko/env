{
  description = "Buddha's reproducible configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-24.11-darwin";
    darwin.url = "github:lnl7/nix-darwin";
    home-manager.url = "github:nix-community/home-manager";

    # Follows
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, darwin, home-manager }:
  let
    system = "aarch64-darwin";
  in {

    nixpkgs.overlays = [
      (final: prev: {
        config = {
          allowUnfree = true;
        };
      })
    ];

    darwinConfigurations.andriibutko = darwin.lib.darwinSystem {
      system = system;
      modules = [
      ./nix/darwin.nix
        home-manager.darwinModules.home-manager
      ];
    };

    homeConfigurations.andriibutko =
      let
        pkgs = import nixpkgs { inherit system; };
      in
      home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs;
        modules = [
        ./nix/home.nix
          {
            home.packages = with pkgs; [
              skhd
              # yabai #... decide to use Aerospace
              #... other Koekeishiya tools
            ];

            programs.zsh.enable = true;
            programs.git.enable = true;
          }
        ];
      };
  };
}