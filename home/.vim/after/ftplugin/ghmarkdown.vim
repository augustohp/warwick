" home/.vim/after/ghmarkdown.vim
"
" @author Augusto Pascutti <augusto.hp@gmail.com>

set textwidth=80
set spell spelllang=en

" Preview markdown
nnoremap <leader>p :!pandoc -c ~/src/gist.github.com/github-pandoc.css --toc -S -s <C-R>% -o /tmp/vim-md-preview.html<CR> :!open /tmp/vim-md-preview.html<CR>
