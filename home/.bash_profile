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
elif [ $(uname) == "Linux" ]
then
    source ~/.bash_profile_ubuntu
fi

source ~/.bash_aliases

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

