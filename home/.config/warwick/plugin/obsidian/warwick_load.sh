# home/.config/warwick/plugin/obsidian/warwick_load.sh
# Obsidian - adds CLI access on macOS

if [ "$(uname)" != "Darwin" ]
then
	return 0
fi

warwick_verbose "Obsidian"

export PATH="$PATH:/Applications/Obsidian.app/Contents/MacOS"
