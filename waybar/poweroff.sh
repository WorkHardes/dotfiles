#! /bin/bash

case $(wofi -d -L 6 -l 3 -W 100 -x -120 -y 0 \
    -D dynamic_lines=true << EOF | sed 's/^ *//'
    Shutdown
    Reboot
    Logout
    Cancel
EOF
) in
    "Shutdown")
        systemctl poweroff;;
    "Reboot")
        systemctl reboot;;
    "Logout")
        swaymsg exit;;
esac
