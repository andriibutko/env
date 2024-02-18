{ config, pkgs, lib, ... }:
{
  home.file.yabai = {
    target = ".config/yabai/yabairc";
    source = ./yabairc;
    executable = true;
  };

  home.file = {
    ".config/yabai/scripts/open_term.sh" = {
      source = ./scripts/open_term.sh;
      executable = true;
    };
    ".config/yabai/scripts/space_cycle_next.sh" = {
      source = ./scripts/space_cycle_next;
      executable = true;
    };
    ".config/yabai/scripts/space_cycle_prev.sh" = {
      source = ./scripts/space_cycle_prev;
      executable = true;
    };
  };

  home.file.skhd = {
    target = ".config/skhd/skhdrc";
    source = ./skhdrc;
    executable = true;
  };
}
