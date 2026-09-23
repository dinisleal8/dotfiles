#!/usr/bin/env bash
#
# Cycle the active keyboard layout (us -> pt -> us ...).
#
# The layout list and the Alt+Shift toggle live in ~/.config/hypr/input.lua
# (kb_layout = "us,pt", kb_options = "...grp:alt_shift_toggle"). This script
# switches layouts from the command line / a Hyprland keybinding.
set -euo pipefail
hyprctl switchxkblayout all next
