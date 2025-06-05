{ config, lib, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Andrii Butko";
    userEmail = "butkoandrea@gmail.com";
    
    aliases = {
      lg = "log --graph --pretty=format:'%Cred%h%Creset %C(bold blue)<%an> -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset'";
      visual = "!gitk";
    };

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      core = {
        editor = "vim";
        autocrlf = false;
      };
      merge = {
        conflictstyle = "diff3";
      };
      diff = {
        colorMoved = "default";
      };
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
      # Bitbucket-specific configuration
      {
        path = "${config.xdg.configHome}/git/bitbucket.config";
        condition = "hasconfig:remote.*.url:*bitbucket.org*";
      }
    ];

    lfs.enable = true;

    # Optional: Configure delta for better diffs
    # delta = {
    #   enable = true;
    #   options = {
    #     navigate = true;
    #     light = false;
    #     side-by-side = true;
    #   };
    # };

    # Optional: Configure signing
    # signing = {
    #   key = null; # Set to your GPG key ID if you use signing
    #   signByDefault = false;
    # };
  };
} 