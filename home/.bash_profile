# ~/.bash_profile
#
# Author Augusto Pascutti <augusto.hp@gmail.com>
# Part of http://github.com/augustohp/warwick
# vim: noet ts=4 sw=4 ft=sh:

# shellcheck disable=SC1091,SC1090

echo 'Loading warwick ...'

# Non-interactive shells skip this =D
[ -z "$PS1" ] && return

export PS1="\W $ "
source "$HOME/.warwick"
warwick_source "$HOME/.bash_environment"

# -----------------------------------------------------------------------------
#                                                                            OS

if [ -f "/etc/debian_version" ]
then
   warwick_source "$HOME/.bash_profile_debian"
fi

if [ "$(uname)" == "Darwin" ];
then
    warwick_source ~/.bash_profile_osx
elif [ -f /proc/version ] && [ -n "$(grep 'microsoft' /proc/version)" ]
then
	warwick_source ~/.bash_profile_wsl
elif uname -a | grep -q aarch64
then
	warwick_source ~/.bash_profile_pi
fi

# Module load ------------------------------------------------------------------

modules_found_path="$(mktemp)"
find "${XDG_CONFIG_HOME}" -type f -name "$WARWICK_MODULE_ENTRYPOINT" >> "$modules_found_path"
find "${XDG_CONFIG_HOME}" -type l -name "$WARWICK_MODULE_ENTRYPOINT" >> "$modules_found_path"
warwick_indent_increase
warwick_verbose "Loading plugins ..."
while IFS= read -r module
do
	warwick_source "$module"
done < "$modules_found_path"
warwick_indent_decrease
rm "$modules_found_path"

warwick_indent_increase

# Homeshick -------------------------------------------------------------------
export HOMESHICK_DIR="${HOME}/.homesick/repos/homeshick"
if [ -d "${HOMESHICK_DIR}" ]
then
	warwick_verbose "Loading Homeshick..."
	warwick_source "${HOMESHICK_DIR}/homeshick.sh"
fi

# Ruby Version manager (RVM) --------------------------------------------------
# https://rvm.io/

export RVM_DIR="$HOME/.rvm"
RVM_SCRIPT="$RVM_DIR/scripts/rvm"
if [ -f "$RVM_SCRIPT" ]
then
	warwick_verbose "Loading rvm..."
	warwick_source "$RVM_SCRIPT"
fi

# Go ---------------------------------------------------------------------------
# https://go.dev

GO_BIN_PATH="$(command -v go)"
if [ -n "$GO_BIN_PATH" ]
then
	warwick_verbose "Loading go..."
	export GOPATH="${HOME}/src"
	export GOBIN="${HOME}/bin"
fi

# -----------------------
# end

warwick_indent_decrease
