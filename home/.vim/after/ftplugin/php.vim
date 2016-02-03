" home/.vim/after/ftplugin/php.vim
"
" @author Augusto Pascutti <augusto.hp@gmail.com>

set showmatch
set expandtab
set tabstop=4
set shiftwidth=4
retab

map <C-e> :PHPClassExplorer<CR>
nnoremap <leader>l :!php -l <C-R>% <CR>
nnoremap <leader>d :Dispatch! vendor/bin/phpunit <C-R>% <CR>
nnoremap <leader>c :!vendor/bin/phpcs --standard=psr2 <C-R>% <CR>

" Removes trailing white spaces
autocmd BufWritePre * :%s/\s\+$//e
