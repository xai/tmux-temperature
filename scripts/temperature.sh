#!/usr/bin/env bash

SDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source "$SDIR/helpers.sh"

get_temperature() {
    local thermal_zone=$(grep -l x86_pkg_temp /sys/class/thermal/thermal_zone*/type | head -n1)
    if [ -f "$thermal_zone" ]; then
		temperature=$(($(cat $(dirname $thermal_zone)/temp) / 1000))
	else
		thermal_zone="$(for i in /sys/devices/pci0000\:00/*/hwmon/hwmon*/*_label; do grep -l Tctl $i; done | head -n1 | sed 's/label$/input/')"
		if [ -f $thermal_zone ]; then
			temperature=$(($(cat $thermal_zone) / 1000))
		else
			echo "N/A"
			return
		fi
    fi
    echo "$temperature °C"
}

update() {
    local temperature=$(get_temperature)
    set_tmux_option "@temperature" "$temperature"
}

main() {
    update
    printf "%s" "$(get_tmux_option "@temperature")"
}

main
