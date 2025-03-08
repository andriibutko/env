{ config, lib, pkgs, ... }:

# References:
#
# https://daiderd.com/nix-darwin/manual/index.html#sec-options
# https://github.com/jwiegley/nix-config/blob/master/config/darwin.nix
# https://github.com/cmacrae/config/blob/master/modules/macintosh.nix

let
  fullName = "Andrii Butko";
  user = builtins.getEnv "USER";
  home = builtins.getEnv "HOME";
  xdg_configHome = "${home}/.config";
in
{

  nix = {
    package = pkgs.nixVersions.stable;

    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    configureBuildUsers = true;
    settings = {
      max-jobs = "auto";
      cores = 0;

      trusted-users = [ "root" "andriibutko" ];

      # TODO: what is public keys?
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      # TODO: what is substituters?
      trusted-substituters = [
        "https://cachix.org/api/v1/cache/nix-community"
        "https://cachix.org/api/v1/cache/deploy-rs"
        "https://hydra.iohk.io"
      ];
    };
  };

  environment = {
    shells = with pkgs; [
      zsh
      bash
    ];
  };

  home-manager = {
    useGlobalPkgs = true;
    users.andriibutko = lib.mkMerge [
      (import ./home.nix)
      {
        imports = [
          ./darwin/yabai.nix
        ];
      }
    ];
  };

  system = {
    stateVersion = 4;

    defaults = {
      NSGlobalDomain = {
        AppleKeyboardUIMode = 3;
        ApplePressAndHoldEnabled = false;
        InitialKeyRepeat = 12;
        KeyRepeat = 2;
        AppleShowAllExtensions = true;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSAutomaticWindowAnimationsEnabled = false;
        NSTableViewDefaultSizeMode = 2;
        _HIHideMenuBar = false;
        "com.apple.keyboard.fnState" = true;
        "com.apple.mouse.tapBehavior" = 1;
        "com.apple.sound.beep.volume" = 0.0;
        "com.apple.sound.beep.feedback" = 0;
      };

      dock = {
        autohide = true;
        expose-group-by-app = true;
        launchanim = false;
        minimize-to-application = true;
        mru-spaces = false;
        orientation = "left";
        show-recents = false;
        static-only = true;
        tilesize = 32;
      };

      finder = {
        AppleShowAllExtensions = true;
      };

      trackpad = {
        Clicking = true;
      };
    };

    keyboard = {
      enableKeyMapping = true;
    };
  };

  ids.gids.nixbld = 350;

  networking.hostName = "ABUT-CAN-MAC";
  users = {
    users.andriibutko = {
      shell = pkgs.fish;
      home = "/Users/andriibutko";
    };
  };

  programs.zsh.enable = true;
  programs.fish.enable = true;

  services = {
    nix-daemon.enable = true;
    activate-system.enable = true;
  };

  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    # onActivation.cleanup = "uninstall"; # removes manually install brews and casks
    brews = [
      "skhd"
    ];
    casks = [
      "telegram"
			"obsidian"
      "visual-studio-code"
      "fork"
      "spotify"
      "iterm2"
      "monitorcontrol"
    ];
    taps = [
      "homebrew/bundle"
      "homebrew/services"
      "koekeishiya/formulae"
    ];
  };
}
