" home/.vim/after/ftplugin/xml.vim
"
" @author Augusto Pascutti <augusto.hp@gmail.com>

setlocal spell! spelllang=en_us
setlocal noet
setlocal ts=4
setlocal sw=4

" Retab upon saving
autocmd BufWritePre * :retab!
autocmd BufWritePre * :%s/\s\+$//e
