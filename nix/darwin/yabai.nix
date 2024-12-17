{ config, pkgs, lib, ... }:
{
  home = {

    file.".config/yabai/scripts" = {
      recursive = true;
      source = ./scripts;
      executable = true;
    };

    file.yabai = {
      target = ".config/yabai/yabairc";
      source = ./yabairc;
      executable = true;
    };

    file.skhd = {
      target = ".config/skhd/skhdrc";
      source = ./skhdrc;
      executable = true;
    };
  };
}
