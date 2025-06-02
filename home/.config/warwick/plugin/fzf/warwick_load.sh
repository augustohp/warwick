#!/usr/bin/env sh
# home/.config/warwick/plugin/fzf/.warwick_load.sh
#
# https://github.com/junegunn/fzf

# Checks if installed
fzf="$(command -v fzf)"
if [ -z "$fzf" ]
then
	return 0
fi

warwick_verbose "fzf"

# Disables keyboard shortcuts to avoid conflicts
FZF_CTRL_T_COMMAND=
FZF_ALT_C_COMMAND=

# Set up fzf key bindings and fuzzy completion
eval "$(fzf --bash)"

# -----------------------------------------------------------------------------
# Support functions

# Finds the root directory of the current Git repository.
# Usage: find_git_root_or_cwd
find_git_root_or_cwd()
{
	git rev-parse --show-toplevel 2> /dev/null || echo "$PWD"
}

# Finds all directories in the given root directory, excluding certain paths.
# Usage: find_dirs <root_directory>
find_dirs()
{
	local root="$1"

	if [ -z "$root" ]
	then
		echo "Error: No root directory provided!" >&2
		#exit 2
	fi

	find "$root" \
		-type d \
		-not -path '*/\.*' \
		-not -path '*/node_modules/*' \
		-not -path '*/vendor/*' \
		-not -path '*/.git/*' \
		-not -path '*/.idea/*' \
		-not -path '*/.vscode/*'
}

# -----------------------------------------------------------------------------
# cd

fd()
{
	local root="${1}"
	local dir

	if [ -z "$root" ]
	then
		root="$(find_git_root_or_cwd)"
	fi

	dir=$(find "$root" -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
	cd "$dir"
}
