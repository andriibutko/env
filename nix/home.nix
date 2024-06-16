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


    fish = {
      enable = true;
      plugins = [
        {
          name = "done";
          src = pkgs.fetchFromGitHub {
            owner = "franciscolourenco";
            repo = "done";
            rev = "37117c3d8ed6b820f6dc647418a274ebd1281832";
            sha256 = "cScH1NzsuQnDZq0XGiay6o073WSRIAsshkySRa/gJc0=";
          };
        }
        {
          name = "plugin-git";
          src = pkgs.fishPlugins.plugin-git.src;
        }
      ];
      shellInit = ''
        # prompt configurations

        set -Ux N_PREFIX $HOME/n/

        # see https://github.com/LnL7/nix-darwin/issues/122
        set -ga PATH ${config.xdg.configHome}/bin
        set -ga PATH $HOME/.local/bin
        set -ga PATH /run/wrappers/bin
        set -ga PATH $HOME/.nix-profile/bin
        if test $KERNEL_NAME darwin
          set -ga PATH /opt/homebrew/opt/llvm/bin
          set -ga PATH /opt/homebrew/bin
          set -ga PATH /opt/homebrew/sbin
        end
        set -ga PATH /run/current-system/sw/bin
        set -ga PATH /nix/var/nix/profiles/default/bin
        macos_set_env prepend PATH /etc/paths '/etc/paths.d'

        export NIXPKGS_ALLOW_INSECURE=1

        function fish_greeting
            # Get the current hour in 24-hour format
            set current_hour $(date +%H)

            # Define the evening hours (6 PM to 11:59 PM)
            set evening_start 18
            set evening_end 23

            if test $current_hour -ge $evening_start -a $current_hour -le $evening_end
                echo -en "Dobry wieczór!\n\n"
            else
                echo -en "Dzień dobry!\n\n"
            end
        end
      '';
    };

    alacritty = {
      enable = true;
      settings = (import ./alacritty.nix);
    };
  };
}
