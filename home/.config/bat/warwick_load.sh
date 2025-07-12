# home/.config/warwick/plugin/php/load.sh
# BAT is a modern pager
#
#

BAT="$(command -v bat)"
if [ -z "$BAT" ]
then
	return 0
fi

warwick_verbose "Bat cat"

export BAT_THEME="Catppuccin Mocha"
export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"

alias bathelp='bat --plain --language=help'

##
# Will display `<command> --help` with syntax highlight
# from "bat".
##
# Usage: help <command>
help() {
    "$@" --help 2>&1 \
		| bathelp
}
