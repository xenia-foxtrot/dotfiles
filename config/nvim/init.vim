set hidden

call plug#begin("~/.local/share/nvim/plugged")

Plug 'vim-airline/vim-airline'

Plug 'airblade/vim-gitgutter'

Plug 'junegunn/vim-easy-align'

" Language client
Plug 'autozimu/LanguageClient-neovim', {'branch': 'next', 'do': 'bash install.sh'}
Plug 'junegunn/fzf'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }


call plug#end()

let g:airline_statusline_ontop=1

set list
set lcs=tab:├─,trail:·
