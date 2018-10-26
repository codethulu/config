let g:ycm_global_ycm_extra_conf = '~/.config/nvim/.ycm_extra_conf.py'
let g:python_host_prog = '/usr/bin/python2'
let g:python3_host_prog = '/usr/bin/python3'

syntax on
filetype plugin indent on

set nu
set list
set ruler

set listchars=tab:\\_,trail:~,extends:>,precedes:<,nbsp:`
if &encoding == "utf-8"
	set listchars=tab:\\_,trail:·,extends:>,precedes:<,nbsp:∆
endif

call plug#begin()
Plug 'vim-erlang/vim-compot'
Plug 'vim-erlang/vim-erlang-omnicomplete'
Plug 'vim-erlang/vim-erlang-runtime'
Plug 'vim-erlang/vim-erlang-skeletons'
Plug 'vim-erlang/vim-erlang-compiler'
"Plug 'vim-erlang/erlang-motions'
Plug 'vim-erlang/vim-dialyzer'

Plug 'vim-syntastic/syntastic'
Plug 'OmniSharp/omnisharp-vim'
Plug 'Valloric/YouCompleteMe'

Plug 'tpope/vim-dispatch'
Plug 'ctrlpvim/ctrlp.vim'

Plug 'morhetz/gruvbox'

Plug 'vim-airline/vim-airline'
Plug 'jacoborus/tender'

Plug 'vimwiki/vimwiki'

call plug#end()

set termguicolors
set bg=dark
"colorscheme compot
colorscheme gruvbox
"colorscheme tender

"if &diff
""	let g:pathogen_disabled = ['omnisharp-vim', 'syntastic', 'YouCompleteMe']
""	execute pathogen#infect()
"else
""	execute pathogen#infect()
"
	set statusline+=%#warningmsg#
	set statusline+=%{SyntasticStatuslineFlag()}
	set statusline+=%*
	
	let g:syntastic_always_populate_loc_list = 1
	let g:syntastic_auto_loc_list = 1
	let g:syntastic_check_on_open = 1
	let g:syntastic_check_on_wq = 0

	let g:syntastic_error_symbol = '⛧'
	let g:syntastic_warning_symbol='☠'

	let g:OmniSharp_selector_ui = 'ctrlp'

	" OmniSharp won't work without this setting
	filetype plugin on
	
	"This is the default value, setting it isn't actually necessary
	let g:OmniSharp_host = "http://localhost:2000"
	
	"Set the type lookup function to use the preview window instead of the status line
	"let g:OmniSharp_typeLookupInPreview = 1
	
	"Timeout in seconds to wait for a response from the server
	let g:OmniSharp_timeout = 1
	
	"Showmatch significantly slows down omnicomplete
	"when the first match contains parentheses.
	set noshowmatch
	
	"Super tab settings - uncomment the next 4 lines
	"let g:SuperTabDefaultCompletionType = 'context'
	"let g:SuperTabContextDefaultCompletionType = "<c-x><c-o>"
	"let g:SuperTabDefaultCompletionTypeDiscovery = ["&omnifunc:<c-x><c-o>","&completefunc:<c-x><c-n>"]
	"let g:SuperTabClosePreviewOnPopupClose = 1
	
	"don't autoselect first item in omnicomplete, show if only one item (for preview)
	"remove preview if you don't want to see any documentation whatsoever.
	set completeopt=longest,menuone,preview
	" Fetch full documentation during omnicomplete requests.
	" There is a performance penalty with this (especially on Mono)
	" By default, only Type/Method signatures are fetched. Full documentation can still be fetched when
	" you need it with the :OmniSharpDocumentation command.
	" let g:omnicomplete_fetch_documentation=1
	
	"Move the preview window (code documentation) to the bottom of the screen, so it doesn't move the code!
	"You might also want to look at the echodoc plugin
	set splitbelow
	
	" Get Code Issues and syntax errors
	let g:syntastic_cs_checkers = ['syntax', 'semantic', 'issues']
	" If you are using the omnisharp-roslyn backend, use the following
	" let g:syntastic_cs_checkers = ['code_checker']
	augroup omnisharp_commands
	    autocmd!
	
	    "Set autocomplete function to OmniSharp (if not using YouCompleteMe completion plugin)
	    autocmd FileType cs setlocal omnifunc=OmniSharp#Complete
	
	    " Synchronous build (blocks Vim)
	    "autocmd FileType cs nnoremap <F5> :wa!<cr>:OmniSharpBuild<cr>
	    " Builds can also run asynchronously with vim-dispatch installed
	    autocmd FileType cs nnoremap <leader>b :wa!<cr>:OmniSharpBuildAsync<cr>
	    " automatic syntax check on events (TextChanged requires Vim 7.4)
	    autocmd BufEnter,TextChanged,InsertLeave *.cs SyntasticCheck
	
	    " Automatically add new cs files to the nearest project on save
	    autocmd BufWritePost *.cs call OmniSharp#AddToProject()
	
	    "show type information automatically when the cursor stops moving
	    autocmd CursorHold *.cs call OmniSharp#TypeLookupWithoutDocumentation()
	
	    "The following commands are contextual, based on the current cursor position.
	
	    autocmd FileType cs nnoremap gd :OmniSharpGotoDefinition<cr>
	    autocmd FileType cs nnoremap <leader>fi :OmniSharpFindImplementations<cr>
	    autocmd FileType cs nnoremap <leader>ft :OmniSharpFindType<cr>
	    autocmd FileType cs nnoremap <leader>fs :OmniSharpFindSymbol<cr>
	    autocmd FileType cs nnoremap <leader>fu :OmniSharpFindUsages<cr>
	    "finds members in the current buffer
	    autocmd FileType cs nnoremap <leader>fm :OmniSharpFindMembers<cr>
	    " cursor can be anywhere on the line containing an issue
	    autocmd FileType cs nnoremap <leader>x  :OmniSharpFixIssue<cr>
	    autocmd FileType cs nnoremap <leader>fx :OmniSharpFixUsings<cr>
	    autocmd FileType cs nnoremap <leader>tt :OmniSharpTypeLookup<cr>
	    autocmd FileType cs nnoremap <leader>dc :OmniSharpDocumentation<cr>
	    "navigate up by method/property/field
	    autocmd FileType cs nnoremap <C-K> :OmniSharpNavigateUp<cr>
	    "navigate down by method/property/field
	    autocmd FileType cs nnoremap <C-J> :OmniSharpNavigateDown<cr>
	
	augroup END
"endif


" this setting controls how long to wait (in ms) before fetching type / symbol information.
set updatetime=500
" Remove 'Press Enter to continue' message when type information is longer than one line.
set cmdheight=2

" Contextual code actions (requires CtrlP or unite.vim)
nnoremap <leader><space> :OmniSharpGetCodeActions<cr>
" Run code actions with text selected in visual mode to extract method
vnoremap <leader><space> :call OmniSharp#GetCodeActions('visual')<cr>

" rename with dialog
nnoremap <leader>nm :OmniSharpRename<cr>
nnoremap <F2> :OmniSharpRename<cr>
" rename without dialog - with cursor on the symbol to rename... ':Rename newname'
command! -nargs=1 Rename :call OmniSharp#RenameTo("<args>")

" Force OmniSharp to reload the solution. Useful when switching branches etc.
nnoremap <leader>rl :OmniSharpReloadSolution<cr>
nnoremap <leader>cf :OmniSharpCodeFormat<cr>
" Load the current .cs file to the nearest project
nnoremap <leader>tp :OmniSharpAddToProject<cr>

" (Experimental - uses vim-dispatch or vimproc plugin) - Start the omnisharp server for the current solution
nnoremap <leader>ss :OmniSharpStartServer<cr>
nnoremap <leader>sp :OmniSharpStopServer<cr>

" Add syntax highlighting for types and interfaces
nnoremap <leader>th :OmniSharpHighlightTypes<cr>
"Don't ask to save when changing buffers (i.e. when jumping to a type definition)
set hidden

" Enable snippet completion, requires completeopt-=preview
let g:OmniSharp_want_snippet=0

" Testing
nnoremap <leader>rt :OmniSharpRunTests<cr>
nnoremap <leader>ra :OmniSharpRunAllTests<cr>

""colorscheme deep-space
""if has(termguicolors)
"  set termguicolors
""  colorscheme compot
""endif
"
"if has("gui_running")
""  colorscheme compot
"endif
"
"set go-=r
"set go-=L
"
autocmd FileType cs set ts=2
autocmd FileType cs set sw=2
autocmd FileType cs set expandtab

autocmd FileType python set ts=4
autocmd FileType python set sw=4
autocmd FileType python set expandtab

autocmd FileType cpp set ts=2
autocmd FileType cpp set sw=2
autocmd FileType cpp set expandtab

autocmd FileType c set ts=2
autocmd FileType c set sw=2
autocmd FileType c set expandtab

nnoremap <leader>sc :lclose<cr>
nnoremap <leader>so :Errors<cr>

" eclim for error tray in java
"autocmd FileType java nnoremap <leader>sc :cclose<cr>
"autocmd FileType java nnoremap <leader>so :ProjectProblems<cr>
"autocmd FileType java nnoremap <leader>b :wa!<cr>:ProjectBuild<cr>
"
"let g:EclimCompletionMethod = 'omnifunc'
"
"nnoremap <leader>n :Bsnext<CR>
"nnoremap <leader>N :Bsprev<CR>
"
set previewheight=50
let g:ycm_autoclose_preview_window_after_insertion = 1

"hi Todo guifg=#222222

let g:vimwiki_list = [{'path': '~/vimwiki/', 'syntax': 'markdown', 'ext': '.md'}]
