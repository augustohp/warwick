# ~/.bash_profile
# 
# Author: Augusto Pascutti <augusto@phpsp.org.br>

if [$(uname) == "Darwin"]; then
    source .bash_profile_osx
fi;

alias l="ls"
alias ll="ls -laht"
