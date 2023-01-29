#! /bin/sh 

# notify send requires DBUS session address to send notification through crontab
# for session other than i3 use the value $DESKTOP_SESSION env variable
export $(grep -E -z DBUS_SESSION_BUS_ADDRESS /proc/$(pgrep -u $LOGNAME i3)/environ | tr '\0' '\n') 


bat_files="/sys/class/power_supply/BAT0"
bat_status=$(cat "${bat_files}/status")
bat_capacity=$(cat "${bat_files}/capacity")

low_battery_icon_path="$HOME/.dotfiles/notifications/icons/low-battery-level.png"
full_battery_icon_path="$HOME/.dotfiles/notifications/icons/full-battery-level.png"

message=$(printf 'Level: %s%s' "$bat_capacity")

if [[ $bat_capacity -lt 15 && $bat_status == 'Discharging' ]]; then
    /usr/bin/notify-send "Low Battery" "${message}" -t 10000 -u normal -i $low_battery_icon_path
fi
if [[ $bat_status == 'Full' || ($bat_status == 'Charging' && $bat_capacity -eq 100) ]]; then
    /usr/bin/notify-send "Full Battery" "${message}" -t 10000 -u normal -i $full_battery_icon_path
fi
