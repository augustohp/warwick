# ~/.bash_aliases
# 
# Author Augusto Pascutti <augusto.hp@gmail.com>
# Part of http://github.com/augustohp/warwick

# Because I am a lazy guy....
alias l='ls'
alias ll='ls -laht'
alias sudo='sudo env PATH=$PATH' # keep current binaries
alias sl="ls"
alias pcat="pygmentize -f terminal256 -O style=native -g"
alias c="clear"
alias ..="cd .."
alias .-="cd -"

if [ "$(uname)" == "Darwin" ]
then
	alias sed=gsed
fi
