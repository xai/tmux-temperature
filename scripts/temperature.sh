#!/usr/bin/env bash

SDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source "$SDIR/helpers.sh"

get_temperature() {
    local thermal_zone=$(grep -l x86_pkg_temp /sys/class/thermal/thermal_zone*/type)
    if [ -z "$thermal_zone" ]; then
        echo "N/A"
        return
    fi
    temperature=$(($(cat $(dirname $thermal_zone)/temp) / 1000))
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
