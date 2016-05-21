" home/.vim/after/ftplugin/go.vim
"
" @author Augusto Pascutti <augusto.hp@gmail.com>

set noexpandtab
set tabstop=4

" Checkstyle of current buffer
nnoremap <leader>c :!gofmt -d -s <C-R>% <CR>

"
" Removes trailing white spaces
autocmd BufWritePre * :%s/\s\+$//e
