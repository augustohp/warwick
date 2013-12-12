" Vagrant (Ruby) syntax file
" Filename:     vagrant.vim
" Language:     Ruby
" Maintainer:   Augusto Pascutti <augusto@phpsp.org.br>
" URL:
" Last Change:
" Version:

augroup vagrant
    au!
    au BufRead,BufNewFile, Vagrantfile set filetype=ruby 
augroup END
