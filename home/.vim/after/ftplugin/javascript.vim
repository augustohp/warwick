" home/.vim/after/ftplugin/javascript.vim
"
" @author Augusto Pascutti <augusto.hp@gmail.com>
"

set noexpandtab
set tabstop=2
set shiftwidth=2
retab

nnoremap <leader>l :!node --check <C-R>% <CR>
nnoremap <leader>d :Dispatch npm test <CR>
