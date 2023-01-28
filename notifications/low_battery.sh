#! /bin/sh 

# notify send requires DBUS session address to send notification through crontab
# for session other than i3 use the value $DESKTOP_SESSION env variable
export $(grep -E -z DBUS_SESSION_BUS_ADDRESS /proc/$(pgrep -u $LOGNAME i3)/environ | tr '\0' '\n') 


bat_files="/sys/class/power_supply/BAT0"
bat_status=$(cat "${bat_files}/status")
bat_capacity=$(cat "${bat_files}/capacity")


message=$(printf 'Your battery is running low (%s%%)' "$bat_capacity")

if [[ $bat_capacity -lt 30 && $bat_status == 'Discharging' ]]; then
    /usr/bin/notify-send "${message}" -t 10000 -u critical
fi

