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
      signing = {
        key = "F9EBF09436BCB50F";
        signByDefault = true;
      };
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
      ];
      shellInit = ''
# prompt configurations

# done configurations
set -g __done_notification_command 'notify send -t "$title" -m "$message"'
set -g __done_enabled 1
set -g __done_allow_nongraphical 1
set -g __done_min_cmd_duration 8000

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


set -ga MANPATH $HOME/.local/share/man
set -ga MANPATH $HOME/.nix-profile/share/man
if test $KERNEL_NAME darwin
  set -ga MANPATH /opt/homebrew/share/man
end
set -ga MANPATH /run/current-system/sw/share/man
set -ga MANPATH /nix/var/nix/profiles/default/share/man
macos_set_env append MANPATH /etc/manpaths '/etc/manpaths.d'

set -gp NIX_PATH nixpkgs=$HOME/.nix-defexpr/channels_root/nixpkgs

if test $KERNEL_NAME darwin
  set -gx HOMEBREW_PREFIX /opt/homebrew
  set -gx HOMEBREW_CELLAR /opt/homebrew/Cellar
  set -gx HOMEBREW_REPOSITORY /opt/homebrew
  set -gp INFOPATH /opt/homebrew/share/info
  set -gx LDFLAGS "-L/opt/homebrew/opt/llvm/lib"
  set -gx CPPFLAGS "-I/opt/homebrew/opt/llvm/include"
end
'';
      interactiveShellInit = ''
set fish_greeting "
                       &    &     &
                        &&&&  &  && &
                &   &     && &&&&&&&
                 &&& &       &&&& &&&
              &&&&& &&& &   /~&&& &&   &&
             && &&&&_&_&_ & \&&&&&&&& && &&
                  &   &&\&&&&__&&&&&&&_/&&&  & &
                         \|\\\__/_/   &&& &
                         \_   _//     & &
                               \\
                                \\
                                //~
                                \\
                                /~
                                 /~
             ;,'             (---./~~\.---)
     _o_    ;:;'   ,          (          )
 ,-.'---`.__ ;      ~,         (________)
((j`~=~=~',-'     ,____.
 `-\     /        |    j
    `-=-'          `--'
"
'';
    };

    alacritty = {
      enable = true;
      settings = (import ./alacritty.nix);
    };
  };
}
