"  +----------------------------------------------+
"  |                                              |
"  |              Installed Plugins               |
"  |                                              |
"  +----------------------------------------------+

" Vundle Init
filetype off
set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'           " Required
Plugin 'Shougo/vimproc.vim'             " Used by other plugins



" ================ Colorschemes ====================
Plugin 'tomasiser/vim-code-dark'
Plugin 'altercation/vim-colors-solarized'



" ================ Interface    ====================
Plugin 'itchyny/lightline.vim'          " Status line
Plugin 'tpope/vim-fugitive'             " Git support
Plugin 'airblade/vim-gitgutter'         " Show git sign column
Plugin 'scrooloose/nerdtree'            " Treeview
Plugin 'Xuyuanp/nerdtree-git-plugin'    " Add git suppor to NerdTree
Plugin 'ryanoasis/vim-devicons'         " Use icons from NerdFonts
Plugin 'jeffkreeftmeijer/vim-numbertoggle' " Hybrid number line



" ================ Syntax/Tags  ====================
Plugin 'Valloric/YouCompleteMe'         " Automatic completion popup
Plugin 'scrooloose/syntastic'           " Syntax cheking
Plugin 'ludovicchabant/vim-gutentags'   " Automatic tags generation
Plugin 'majutsushi/tagbar'              " Indexed tags window
Plugin 'janko-m/vim-test'



" ================ Style/Format ====================
Plugin 'sheerun/vim-polyglot'           " Syntax highlighting pack
Plugin 'Chiel92/vim-autoformat'         " Autoformatting using external tools
Plugin 'ntpeters/vim-better-whitespace' " Highlight trailing whitespaces



" ================ Mappings     ====================
Plugin 'jiangmiao/auto-pairs'           " Auto pair braces
Plugin 'tpope/vim-surround'             " Mappings to change braces
Plugin 'tpope/vim-commentary'           " Auto comment with gc
Plugin 'tpope/vim-repeat'               " Repeat mapppings from plugins
Plugin 'vim-scripts/a.vim'              " Swap between .h and .cpp files
Plugin 'junegunn/fzf.vim'



" ================ Python       ====================
Plugin 'nvie/vim-flake8'                " PEP 8 checking
Plugin 'Vimjas/vim-python-pep8-indent'



" ================ Ruby         ====================
Plugin 'vim-ruby/vim-ruby'
Plugin 'tpope/vim-rails'



call vundle#end()
filetype plugin indent on

