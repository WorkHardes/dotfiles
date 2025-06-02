#!/usr/bin/env bash

# swaylock \
# 		--screenshots \
# 		--clock \
# 		--timestr "%H:%M:%S" \
# 		--datestr "%A, %d-%m-%Y" \
# 		--indicator-idle-visible \
# 		--indicator-radius 110 \
# 		--indicator-thickness 8 \
# 		--fade-in 0.5 \
# 		--ring-color 455a64 \
# 		--key-hl-color be5046 \
# 		--text-color ffc107 \
# 		--line-color 00000000 \
# 		--inside-color 00000088 \
# 		--separator-color 00000000 \
# 		--effect-blur 8x4 \
# 		--effect-vignette 0.5:0.5

hyprlock -c $HOME/.config/hypr/hyprlock/hyprlock.conf
