" home/.vim/after/gitcommit.vim
"
" @author Augusto Pascutti <augusto.hp@gmail.com>

set textwidth=72
set spell spelllang=en

" On the line of a file: Show its diff an an split.
nnoremap <leader>d ^f:wy$:new \| read !git diff --cached *<C-R>"<CR>:set ft=diff<CR>
nnoremap <leader>c :bdelete!<CR>
