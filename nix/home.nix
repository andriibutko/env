{ config, lib, pkgs, ... }:

# References:
#

let
  home = config.home.homeDirectory;
  tmpdir = "/tmp";
in
{
  home = {
    # These are packages that should always be present in the user
    # environment, though perhaps not the machine environment.
    packages = pkgs.callPackage ./packages.nix { };

    stateVersion = "22.11";

    sessionVariables = {
      NIX_CONF = "${config.xdg.configHome}/nix";
      PROJECTS_HOME = "${home}/Developer";
      XDG_CACHE_HOME = config.xdg.cacheHome;
      XDG_CONFIG_HOME = config.xdg.configHome;
      XDG_DATA_HOME = config.xdg.dataHome;
      QT_XCB_GL_INTEGRATION = "none";
    };
    sessionPath = [ ];

  };

  xdg.enable = true;

  fonts.fontconfig.enable = true;

  programs = {
    git = {
      enable = true;
      userName = "Andrii Butko";
      userEmail = "butkoandrea@gmail.com";
      aliases = {
        lg = "log --graph --pretty=format:'%Cred%h%Creset %C(bold blue)<%an> -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset'";
      };
      extraConfig = {
        magithub = {
          online = true;
        };
        github = {
          user = "yourzbuddha";
        };
      };
      includes = [
        {
          path = "${config.xdg.configHome}/git/local.config";
        }
      ];
      lfs.enable = true;
    };

    zsh = {
      plugins = [
        {
          # will source zsh-autosuggestions.plugin.zsh
          name = "zsh-autosuggestions";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-autosuggestions";
            rev = "v0.4.0";
            sha256 = "0z6i9wjjklb4lvr7zjhbphibsyx51psv50gm07mbb0kj9058j6kc";
          };
        }
        {
          name = "enhancd";
          file = "init.sh";
          src = pkgs.fetchFromGitHub {
            owner = "b4b4r07";
            repo = "enhancd";
            rev = "v2.2.1";
            sha256 = "0iqa9j09fwm6nj5rpip87x3hnvbbz9w9ajgm6wkrd5fls8fn8i5g";
          };
        }
      ];
    };

    alacritty = {
      enable = true;
      settings = (import ./alacritty.nix);
    };
  };
}
