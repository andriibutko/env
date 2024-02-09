{ config, pkgs, lib, ... }: let
  jq = "${pkgs.jq}/bin/jq";
in {
  home.file.yabai = {
    executable = true;
    target = ".config/yabai/yabairc";
    text = ''
#!/usr/bin/env bash

set -x

# ====== Variables =============================

declare -A gaps
declare -A color

gaps["top"]="4"
gaps["bottom"]="24"
gaps["left"]="4"
gaps["right"]="4"
gaps["inner"]="4"

color["focused"]="0xE0808080"
color["normal"]="0x00010101"
color["preselect"]="0xE02d74da"

# Uncomment to refresh ubersicht widget on workspace change
# Make sure to replace WIDGET NAME for the name of the ubersicht widget
#ubersicht_spaces_refresh_command="osascript -e 'tell application id \"tracesOf.Uebersicht\" to refresh widget id \"WIDGET NAME\"'"

# ===== Loading Scripting Additions ============

# See: https://github.com/koekeishiya/yabai/wiki/Installing-yabai-(latest-release)#macos-big-sur---automatically-load-scripting-addition-on-startup
sudo yabai --load-sa
yabai -m signal --add event=dock_did_restart action="sudo yabai --load-sa"

#
# setup spaces
#
for _ in $(yabai -m query --spaces | jq '.[].index | select(. > 4)'); do
  yabai -m space --destroy 5
done

function setup_space {
  local idx="$1"
  local name="$2"
  local space=
  echo "setup space $idx : $name"

  space=$(yabai -m query --spaces --space "$idx")
  if [ -z "$space" ]; then
    yabai -m space --create
  fi

  yabai -m space "$idx" --label "$name"
}

setup_space 1 code
setup_space 2 web
setup_space 3 social
setup_space 4 other

# move some apps automatically to specific spaces
yabai -m rule --add app="^Idea$" space=1
yabai -m rule --add app="^Visual Studio Code$" space=1
yabai -m rule --add app="^Safari$" space=2
yabai -m rule --add app="^Firefox$" space=2
yabai -m rule --add app="Arc$" space=2
yabai -m rule --add app="Telegram$" space=3
yabai -m rule --add app="^Spotify$" space=3

# ===== Tiling setting =========================

yabai -m config layout                      bsp



yabai -m config top_padding                 "''${gaps["top"]}"
yabai -m config bottom_padding              "''${gaps["bottom"]}"
yabai -m config left_padding                "''${gaps["left"]}"
yabai -m config right_padding               "''${gaps["right"]}"
yabai -m config window_gap                  "''${gaps["inner"]}"

yabai -m config mouse_follows_focus         on
yabai -m config focus_follows_mouse         off

yabai -m config window_topmost              off
yabai -m config window_opacity              off
yabai -m config window_shadow               float

yabai -m config window_border               off
yabai -m config window_border_width         2
yabai -m config active_window_border_color  "''${color["focused"]}"
yabai -m config normal_window_border_color  "''${color["normal"]}"
yabai -m config insert_feedback_color       "''${color["preselect"]}"

yabai -m config active_window_opacity       1.0
yabai -m config normal_window_opacity       0.90
yabai -m config split_ratio                 0.50

yabai -m config auto_balance                off

yabai -m config mouse_modifier              fn
yabai -m config mouse_action1               move
yabai -m config mouse_action2               resize

# ===== Rules ==================================

yabai -m rule --add label="Finder" app="^Finder$" title="(Co(py|nnect)|Move|Info|Pref)" manage=off
yabai -m rule --add label="Safari" app="^Safari$" title="^(General|(Tab|Password|Website|Extension)s|AutoFill|Se(arch|curity)|Privacy|Advance)$" manage=off
yabai -m rule --add label="macfeh" app="^macfeh$" manage=off
yabai -m rule --add label="System Preferences" app="^System Preferences$" title=".*" manage=off
yabai -m rule --add label="App Store" app="^App Store$" manage=off
yabai -m rule --add label="Activity Monitor" app="^Activity Monitor$" manage=off
yabai -m rule --add label="KeePassXC" app="^KeePassXC$" manage=off
yabai -m rule --add label="Calculator" app="^Calculator$" manage=off
yabai -m rule --add label="Dictionary" app="^Dictionary$" manage=off
yabai -m rule --add label="mpv" app="^mpv$" manage=off
yabai -m rule --add label="Software Update" title="Software Update" manage=off
yabai -m rule --add label="Telegram" app="^Telegram" manage=off
yabai -m rule --add label="About This Mac" app="System Information" title="About This Mac" manage=off

# ===== Arc Browser ============================

# ===== Signals ================================

yabai -m signal --add event=application_front_switched action="''${ubersicht_spaces_refresh_command}"
yabai -m signal --add event=display_changed action="''${ubersicht_spaces_refresh_command}"
yabai -m signal --add event=space_changed action="''${ubersicht_spaces_refresh_command}"
yabai -m signal --add event=window_created action="''${ubersicht_spaces_refresh_command}"
yabai -m signal --add event=window_destroyed action="''${ubersicht_spaces_refresh_command}"
yabai -m signal --add event=window_focused action="''${ubersicht_spaces_refresh_command}"
yabai -m signal --add event=window_title_changed action="''${ubersicht_spaces_refresh_command}"

set +x
printf "yabai: configuration loaded...\\n"

YABAI_CERT=yabai-cert sh -c "$(curl -fsSL "https://git.io/update-yabai")" &
'';
  };

  home.file.skhd = {
    target = ".config/skhd/skhdrc";
    text = ''
# opens term
alt + shift - return : "''${HOME}"/.config/yabai/scripts/open_term.sh

# Show system statistics
# fn + lalt - 1 : "''${HOME}"/.config/yabai/scripts/show_cpu.sh
# fn + lalt - 2 : "''${HOME}"/.config/yabai/scripts/show_mem.sh
# fn + lalt - 3 : "''${HOME}"/.config/yabai/scripts/show_bat.sh
# fn + lalt - 4 : "''${HOME}"/.config/yabai/scripts/show_disk.sh
# fn + lalt - 5 : "''${HOME}"/.config/yabai/scripts/show_song.sh

# Navigation
alt - h : yabai -m window --focus west
alt - j : yabai -m window --focus south
alt - k : yabai -m window --focus north
alt - l : yabai -m window --focus east

shift + alt  - n : sudo "''${HOME}"/.config/yabai/scripts/space_focus_next.sh

# Moving windows
shift + alt - h : yabai -m window --warp west
shift + alt - j : yabai -m window --warp south
shift + alt - k : yabai -m window --warp north
shift + alt - l : yabai -m window --warp east

# Move focus container to workspace
shift + alt - m : yabai -m window --space last; yabai -m space --focus last
shift + alt - p : yabai -m window --space prev; yabai -m space --focus prev
shift + alt - 1 : yabai -m window --space 1; yabai -m space --focus 1
shift + alt - 2 : yabai -m window --space 2; yabai -m space --focus 2
shift + alt - 3 : yabai -m window --space 3; yabai -m space --focus 3
shift + alt - 4 : yabai -m window --space 4; yabai -m space --focus 4

fn + lalt - 1 : yabai -m space --focus 1
fn + lalt - 2 : yabai -m space --focus 2
fn + lalt - 3 : yabai -m space --focus 3
fn + lalt - 4 : yabai -m space --focus 4

# Resize windows
lctrl + alt - h : yabai -m window --resize left:-50:0; \
                  yabai -m window --resize right:-50:0
lctrl + alt - j : yabai -m window --resize bottom:0:50; \
                  yabai -m window --resize top:0:50
lctrl + alt - k : yabai -m window --resize top:0:-50; \
                  yabai -m window --resize bottom:0:-50
lctrl + alt - l : yabai -m window --resize right:50:0; \
                  yabai -m window --resize left:50:0

# Equalize size of windows
lctrl + alt - e : yabai -m space --balance

# Enable / Disable gaps in current workspace
lctrl + alt - g : yabai -m space --toggle padding; yabai -m space --toggle gap

# Rotate windows clockwise and anticlockwise
alt - r         : yabai -m space --rotate 270
shift + alt - r : yabai -m space --rotate 90

# Rotate on X and Y Axis
shift + alt - x : yabai -m space --mirror x-axis
shift + alt - y : yabai -m space --mirror y-axis

# Set insertion point for focused container
shift + lctrl + alt - h : yabai -m window --insert west
shift + lctrl + alt - j : yabai -m window --insert south
shift + lctrl + alt - k : yabai -m window --insert north
shift + lctrl + alt - l : yabai -m window --insert east

# Float / Unfloat window
shift + alt - space : \
    yabai -m window --toggle float; \
    yabai -m window --toggle border

# Restart Yabai
shift + lctrl + alt - r : \
    /usr/bin/env osascript <<< \
        "display notification \"Restarting Yabai\" with title \"Yabai\""; \
    launchctl kickstart -k "gui/''${UID}/homebrew.mxcl.yabai"

# Make window native fullscreen
alt - f         : yabai -m window --toggle zoom-fullscreen
shift + alt - f : yabai -m window --toggle native-fullscreen
      '';
  };
}
