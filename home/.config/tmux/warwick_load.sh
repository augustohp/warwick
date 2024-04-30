# home/.config/warwick/plugin/tmux/warwick_load.sh
#
# tmux
#
# Author: Augusto Pascutti <augusto.hp+oss@gmail.com>

#------------------------------------------------------------------------------

TMUX_CONFIG_FILE="$XDG_CONFIG_HOME/tmux/tmux.conf"
TMUX_PATH="$(command -v tmux)"

if [ -z "$TMUX_PATH" ]
then
	# tmux not installed, bailing out
	return 0
fi

#------------------------------------------------------------------------------


warwick_verbose "Tmux"

TPM_INSTALL_DIR="${HOME}/.tmux/plugins/tpm"
if [ ! -d "${TPM_INSTALL_DIR}" ]
then
	warwick_verbose_inside "Installing tpm..."
	git clone https://github.com/tmux-plugins/tpm "$TPM_INSTALL_DIR"
fi

# Wraps "tmux" to allow config file placement through environment vars
# Usage: tmux <commands>
tmux()
{
	TMUX_PATH -f "$TMUX_CONFIG_FILE" "$@"
}
