# ~/.bash_profile
#
# Author: Augusto Pascutti <augusto@phpsp.org.br>
# Part of http://github.com/augustohp/warwick

echo 'General profile.'

# Non-interactive shells skip this =D
[ -z "$PS1" ] && return

source $HOME/.bash_environment

# Special .bash_profile for OSX
if [ $(uname) == "Darwin" ]; then
    source ~/.bash_profile_osx
elif [ $(uname) == "Linux" ]; then
    source ~/.bash_profile_ubuntu
fi;

# If humanshell/phpenv is installed, use it
if [ -d $PHPENV_PATH ]; then
    echo "PHPENV loaded.";
	export PATH="$PHPENV_PATH:$PATH"
	eval "$(phpenv init -)"
fi;

# If c9s/phpbrew is installed, use it
if [ -d $PHPBREW_PATH ]; then
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

# Because I am a lazy guy....
alias l='ls'
alias ll='ls -laht'
alias sudo='sudo env PATH=$PATH'
alias sl="ls"
alias pcat="pygmentize -f terminal256 -O style=native -g"

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

