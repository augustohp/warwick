#!/usr/bin/env sh
# home/.config/warwick/plugin/zoxide/.warwick_load.sh
#
# https://github.com/ajeetdsouza/zoxide

# Checks if installed
zoxide="$(command -v zoxide)"
if [ -z "$zoxide" ]
then
	return 0
fi

warwick_verbose "zoxide"

export _ZO_DOCTOR=0
eval "$(zoxide init bash)"

# -----------------------------------------------------------------------------
# Support functions

##
# Will add recent directories to zoxide database
##
# Usage: zoxide_feed
zoxide_feed()
{
	for d in $(history | grep 'cd' | awk '{ print $3}' | sort | uniq)
	do
		test -d "$d" && { zoxide add "$d"; }
	done

	find "$HOME" -type d -name ".git" -exec zoxide add "$d" \;
}

