# ~/.bash_profile
# 
# Author: Augusto Pascutti <augusto@phpsp.org.br>

# Non-interactive shellsskip this =D
[ -z "$PS1" ] && return

# Special .bash_profile for OSX
if [$(uname) == "Darwin"]; then
    source .bash_profile_osx
fi;

# If humanshell/phpenv is installed, use it
if [-f "$HOME/.phpenv]; then
	export PATH="$HOME/.phpenv/bin:$PATH"
	eval "$(phpenv init -)"
fi;

alias l='ls'
alias ll='ls -laht'
