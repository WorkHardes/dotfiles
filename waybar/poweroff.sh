#!/usr/bin/env bash

display_menu() {
    wofi_cmd="wofi -d -l 3 -W 100 -x -90 -y 0 -L 6"
    echo -e "Shutdown\nReboot\nLogout\nCancel" | $wofi_cmd
}

choice=$(display_menu | sed 's/^ *//')

case "$choice" in
    "Shutdown")
        systemctl poweroff
    ;;
    "Reboot")
        systemctl reboot
    ;;
    "Logout")
        swaymsg exit
    ;;
esac
