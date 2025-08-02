# home/.config/claude/warwick_load.sh
#
# Part of https://github.com/augustohp/warwick

warwick_verbose "Claude"

# If the installation is local, define alias
CLAUDE_LOCAL_INSTALL_PATH="$HOME/.claude/local/claude"
if [ -f "$CLAUDE_LOCAL_INSTALL_PATH" ]
then
	CLAUDE_LOCAL_DIR="$(dirname "$CLAUDE_LOCAL_INSTALL_PATH")"
	warwick_verbose_inside "Local install on '${CLAUDE_LOCAL_DIR}'..."
	export PATH="$CLAUDE_LOCAL_DIR:$PATH"
fi
