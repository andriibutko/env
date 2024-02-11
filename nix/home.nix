{ config, lib, pkgs, ... }:

# References:
#

let
  home         = config.home.homeDirectory;
  tmpdir       = "/tmp";
in {
  home = {
    # These are packages that should always be present in the user
    # environment, though perhaps not the machine environment.
    packages = pkgs.callPackage ./packages.nix {};

    stateVersion = "22.11";

    sessionVariables = {
      NIX_CONF              = "${config.xdg.configHome}/nix";
      PROJECTS_HOME         = "${home}/Developer";
      XDG_CACHE_HOME        = config.xdg.cacheHome;
      XDG_CONFIG_HOME       = config.xdg.configHome;
      XDG_DATA_HOME         = config.xdg.dataHome;
      QT_XCB_GL_INTEGRATION = "none";
    };
    sessionPath = [];

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
      # signing = {
      #   key = "F9EBF09436BCB50F";
      #   signByDefault = true;
      # };
      lfs.enable = true;
    };


    # gpg = {
    #   enable = true;
    #   settings = {
    #     default-key = "F9EBF09436BCB50F";

    #     auto-key-locate = "keyserver";
    #     keyserver = "hkps://hkps.pool.sks-keyservers.net";
    #     keyserver-options = "no-honor-keyserver-url include-revoked auto-key-retrieve";
    #   };
    #   scdaemonSettings = {
    #     card-timeout = "1";
    #     disable-ccid = true;
    #     pcsc-driver = "/System/Library/Frameworks/PCSC.framework/PCSC";
    #   };
    # };

    ssh = {
      enable = true;

      controlMaster  = "auto";
      controlPath    = "${tmpdir}/ssh-%u-%r@%h:%p";
      controlPersist = "1800";

      forwardAgent = true;
      serverAliveInterval = 60;

      hashKnownHosts = true;
      userKnownHostsFile = "${home}/.ssh/known_hosts";

      matchBlocks = {
        keychain = {
          host = "*";
          extraOptions = {
            UseKeychain    = "yes";
            AddKeysToAgent = "yes";
            IgnoreUnknown  = "UseKeychain";
          };
        };
      };
    };

# TODO: add the current fish plugis
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
    };
  };
}
