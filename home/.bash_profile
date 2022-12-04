# ~/.bash_profile
#
# Author Augusto Pascutti <augusto.hp@gmail.com>
# Part of http://github.com/augustohp/warwick

echo 'Loading warwick ...'

# Non-interactive shells skip this =D
[ -z "$PS1" ] && return

source $HOME/.bash_environment

if [ $(uname) == "Darwin" ];
then
    source ~/.bash_profile_osx
elif [ ! -z "$(grep 'microsoft' /proc/version)" ]
then
	source ~/.bash_profile_wsl
fi

alias l='ls'
alias ll='ls -laht'
alias sudo="sudo env PATH=\"${PATH}\"" # keep current binaries
alias sl="ls"
alias pcat="pygmentize -f terminal256 -O style=native -g"
alias c="clear"
alias ..="cd .."
alias .-="cd -"

# If c9s/phpbrew is installed, use it
if [ -d "$PHPBREW_PATH" ]; then
    source "$PHPBREW_PATH/bashrc"
    PHPBREW_VERSION="$(phpbrew info | head -n 2 | tail -n 1)"
    echo "PHPBrew loaded. (${PHPBREW_VERSION})"
fi;

# Search for a binary path inside home
if [ -d "$HOME/bin" ]; then
	export PATH="$HOME/bin:$PATH"
fi;

# Add heroku toolbelt
if [ -d "$HEROKU_TOOLBET_PATH" ]; then
    export PATH="$HEROKU_TOOLBET_PATH:$PATH"
fi;


# User specific environment and startup programs
git_parse_dirty()
{
    test "$(git diff HEAD --name-only  2>/dev/null 2>&1)" \
        && echo " *"
}

git_branch_name()
{
    git branch 2>/dev/null \
      | grep -e "^*" \
      | cut -d "_" -f 1 \
      | sed -E "s/^\* (.+)$/(\1$(git_parse_dirty)) /"
}

# Homeshick -------------------------------------------------------------------
export HOMESHICK_DIR="${HOME}/.homesick/repos/homeshick"
if [ -d "${HOMESHICK_DIR}" ]
then
	echo "Loading Homeshick..."
	source "${HOMESHICK_DIR}/homeshick.sh"
fi

export SDKMAN_DIR="/home/augusto/.sdkman"
[[ -s "/home/augusto/.sdkman/bin/sdkman-init.sh" ]] && source "/home/augusto/.sdkman/bin/sdkman-init.sh"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
[[ -f "$HOME/.bashrc_creditas" ]] && source "$HOME/.bashrc_creditas"

# Zoxide -----------------------------------------------------------------------
# https://github.com/ajeetdsouza/zoxide

if [ -n "$(command -v zoxide)" ]
then
	eval "$(zoxide init bash)"
fi

# Will add recent directories to zoxide database
# Usage: zoxide_feed
zoxide_feed()
{
	for d in `history | grep 'cd' | awk '{ print $3}' | sort | uniq`
	do 
		test -d "$d" && { z "$d"; z -; }
	done
}


# Node Version Mamager (NVM) ----------------------------------------------------
# https://nodecli.com/nodejs-nvm

export NVM_DIR="$HOME/.nvm"
if [ -z "$NVM_DIR/nvm.sh" ]
then
	echo "Loading nvm..."
	source "$NVM_DIR/nvm.sh"
	source "$NVM_DIR/bash_completion"
fi
