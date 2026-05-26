# home/.config/warwick/plugin/obsidian/warwick_load.sh
# Obsidian - adds CLI access on macOS and WSL
#
# On WSL, aliases `obsidian` to `Obsidian.com`, the terminal redirector
# shipped next to Obsidian.exe (the bare .exe is a GUI app and can't
# talk to a terminal). The CLI remote-controls the running Obsidian
# app - if it isn't open on Windows, the first call will launch it.

if [ "$(uname)" = "Darwin" ]
then
	warwick_verbose "Obsidian"
	export PATH="$PATH:/Applications/Obsidian.app/Contents/MacOS"
	return 0
fi

if [ -z "$WSL_HOME" ]
then
	return 0
fi

OBSIDIAN_WIN_BIN="/mnt/c/Users/augus/AppData/Local/Programs/Obsidian/Obsidian.com"
if [ ! -f "$OBSIDIAN_WIN_BIN" ]
then
	return 0
fi

warwick_verbose "Obsidian (Obsidian.com)"

alias obsidian="$OBSIDIAN_WIN_BIN"
