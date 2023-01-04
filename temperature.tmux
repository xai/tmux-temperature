#!/usr/bin/env bash

SDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source "$SDIR/scripts/helpers.sh"

temperature_interpolation="\#{temperature}"
temperature="#($SDIR/scripts/temperature.sh)"

do_interpolation() {
    local result=$1
    result="${result/$temperature_interpolation/$temperature}"
    echo "$result"
}

update_tmux_option() {
    local option option_value
    option=$1
    option_value=$(get_tmux_option "$option")
    set_tmux_option "$option" "$(do_interpolation "$option_value")"
}

main() {
    update_tmux_option "status-right"
    update_tmux_option "status-left"
}
main