{ config, lib, pkgs, ... }:

# References:
#

let
  home = config.home.homeDirectory;
  tmpdir = "/tmp";
in
{
  imports = [
    ./git.nix
  ];

  home = {
    username = "andriibutko";
    homeDirectory = "/Users/andriibutko";
    
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
    sessionPath = [ 
      "$HOME/.local/bin"
      "$HOME/bin"
    ];

  };

  xdg.enable = true;

  fonts.fontconfig.enable = true;

  programs = {
    zsh = {
      enable = true;
      
      # Oh My Zsh configuration
      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [
          "git"
          "docker"
          "kubectl"
          "terraform"
          "aws"
          "brew"
          "macos"
        ];
      };

      # Environment variables specific to zsh
      envExtra = ''
        export PATH="$HOME/.local/bin:$HOME/bin:$PATH"
      '';

      # Shell aliases (fully reproducible)
      shellAliases = {
        # Basic aliases
        grep = "grep --color=auto";
        
        glog = "git log --oneline --graph --decorate";
        
        # System aliases
        reload = "source ~/.zshrc";
      };

      # Custom initialization (runs after oh-my-zsh)
      # Only put truly machine-specific things in local files
      initExtra = ''
        # Reproducible configuration
        setopt AUTO_CD              # cd by typing directory name if it's not a command
        setopt CORRECT_ALL          # autocorrect commands
        setopt SHARE_HISTORY        # share history between sessions
        
        # Only source local config for truly machine-specific things
        # (like work VPN settings, specific server IPs, API keys, etc.)
        if [[ -f "$HOME/.zshrc.local" ]]; then
          source "$HOME/.zshrc.local"
        fi
      '';

      # Shell options
      history = {
        size = 50000;
        save = 50000;
        path = "${config.xdg.dataHome}/zsh/history";
        ignoreDups = true;
        share = true;
        extended = true;
      };

      # Additional plugins (beyond oh-my-zsh)
      plugins = [
        {
          name = "zsh-autosuggestions";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-autosuggestions";
            rev = "v0.7.0";
            sha256 = "0z6i9wjjklb4lvr7zjhbphibsyx51psv50gm07mbb0kj9058j6kc";
          };
        }
        {
          name = "zsh-syntax-highlighting";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-syntax-highlighting";
            rev = "0.8.0";
            sha256 = "0zmq66dzasmr5pwribyh4kbkk23jxbpdw4rjxx0i7dx8jjp2lzl4";
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
  };
}
