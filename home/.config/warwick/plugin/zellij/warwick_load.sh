# home/.config/warwick/plugin/zellij/warwick_load.sh
#
# Zellij support
# https://zellij.dev/

ZELLIJ="$(command -v zellij)"

if [ -z "$ZELLIJ" ]
then
	return
fi

warwick_verbose "Zellij"

export ZELLIJ_CONFIG_DIR="$HOME/.config/warwick/plugin/zellij"
ZELLIJ_CACHE_DIR="$XDG_RUNTIME_DIR/zellij"

##
# Will check cache directory permission before launching
# zellij.
##
# Usage: zellij [options] [command]
zellij()
{
	if [ ! -x "$ZELLIJ_CACHE_DIR" ]
	then
		sudo mkdir "$ZELLIJ_CACHE_DIR"
		sudo chown "$USER":"$USER" "$ZELLIJ_CACHE_DIR"
	fi

	$ZELLIJ "$@"
}
