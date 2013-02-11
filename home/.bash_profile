# ~/.bash_profile
# 
# Author: Augusto Pascutti <augusto@phpsp.org.br>

PHPENV_PATH="$HOME/.phpenv/bin"

# Non-interactive shells skip this =D
[ -z "$PS1" ] && return

# Special .bash_profile for OSX
if [ $(uname) == "Darwin" ]; then
    source ~/.bash_profile_osx
elif [ $(uname) == "Linux" ]; then
    source ~/.bash_profile_ubuntu
fi;

# If humanshell/phpenv is installed, use it
if [ -d $PHPENV_PATH ]; then
	export PATH="$PHPENV_PATH:$PATH"
	eval "$(phpenv init -)"
fi;

# Search for a binary path inside home
if [ -d "$HOME/bin" ]; then
	export PATH="$HOME/bin:$PATH"
fi;

alias l='ls'
alias ll='ls -laht'
alias sudo='sudo env PATH=$PATH'

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
 
<<<<<<< HEAD
PS1="\u [\w] \$(type git_branch_name &>/dev/null && git_branch_name)$ "
export PS1
=======
export PS1="[\w] \$(type git_branch_name &>/dev/null && git_branch_name)$ "
>>>>>>> 9a5e3bc3f8d29dc0938720f287d8714adf286415
