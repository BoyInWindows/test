" =============================================================================
"        << 判断操作系统是 Windows 还是 Linux 和判断是终端还是 Gvim >>
" =============================================================================
"{{{ ->iswindows  isGUI
 
" -----------------------------------------------------------------------------
"  < 判断操作系统是否是 Windows 还是 Linux >
" -----------------------------------------------------------------------------
if(has("win32") || has("win64") || has("win95") || has("win16"))
    let g:iswindows = 1
else
    let g:iswindows = 0
endif
 
" -----------------------------------------------------------------------------
"  < 判断是终端还是 Gvim >
" -----------------------------------------------------------------------------
if has("gui_running")
    let g:isGUI = 1
else
    let g:isGUI = 0
endif
 
"}}}
" =============================================================================
"                          << 以下为软件默认配置 >>
" ============================================================================= 
"{{{ -> ceshi
"echo $VIM
"}}}
" -----------------------------------------------------------------------------
"  < Windows Gvim 默认配置> 做了一点修改
" -----------------------------------------------------------------------------
"{{{ ->windows 配置

if (g:iswindows && g:isGUI)
    source $VIMRUNTIME/vimrc_example.vim
    " source $VIMRUNTIME/mswin.vim                     "取消windows兼容 
    " behave mswin
    set diffexpr=MyDiff()

    function! MyDiff()
        let opt = '-a --binary '
        if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
        if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
        let arg1 = v:fname_in
        if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
        let arg2 = v:fname_new
        if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
        let arg3 = v:fname_out
        if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
        let eq = ''
        if $VIMRUNTIME =~ ' '
            if &sh =~ '\<cmd'
                let cmd = '""' . $VIMRUNTIME . '\diff"'
                let eq = '"'
            else
                let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
            endif
        else
            let cmd = $VIMRUNTIME . '\diff'
        endif
        silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
    endfunction
endif

"}}}
" -----------------------------------------------------------------------------
"  < Linux Gvim/Vim 默认配置> 做了一点修改
" -----------------------------------------------------------------------------
"{{{ ->Linus 配置
if !g:iswindows
    set hlsearch        "高亮搜索
    set incsearch       "在输入要搜索的文字时，实时匹配
 
    " Uncomment the following to have Vim jump to the last position when
    " reopening a file
    if has("autocmd")
        au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
    endif
 
    if g:isGUI
        " Source a global configuration file if available
        if filereadable("/etc/vim/gvimrc.local")
            source /etc/vim/gvimrc.local
        endif
    else
        " This line should not be removed as it ensures that various options are
        " properly set to work with the Vim-related packages available in Debian.
        runtime! debian.vim
 
        " Vim5 and later versions support syntax highlighting. Uncommenting the next
        " line enables syntax highlighting by default.
        if has("syntax")
            syntax on
        endif
 
        set mouse=a                    " 在任何模式下启用鼠标
        set t_Co=256                   " 在终端启用256色
        set backspace=2                " 设置退格键可用
 
        " Source a global configuration file if available
        if filereadable("/etc/vim/vimrc.local")
            source /etc/vim/vimrc.local
        endif
    endif
endif
 
"}}}
" =============================================================================
"                          << 以下为用户自定义配置 >>
" =============================================================================
" -----------------------------------------------------------------------------
"  < 编码配置 >
" -----------------------------------------------------------------------------
"{{{
" 注：使用utf-8格式后，软件与程序源码、文件路径不能有中文，否则报错
set encoding=utf-8                                    "设置gvim内部编码
set fileencoding=utf-8                                "设置当前文件编码
set fileencodings=ucs-bom,utf-8,gbk,cp936,latin-1     "设置支持打开的文件的编码
 
" 文件格式，默认 ffs=dos,unix
set fileformat=unix                                   "设置新文件的<EOL>格式
set fileformats=unix,dos,mac                          "给出文件的<EOL>格式类型
 
if (g:iswindows && g:isGUI)
    "解决菜单乱码
    source $VIMRUNTIME/delmenu.vim
    source $VIMRUNTIME/menu.vim
 
    "解决consle输出乱码
    language messages zh_CN.utf-8
endif

"set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
"set scrolloff=3
"set fenc=utf-8
"set autoindent
"set hidden
"set noswapfile
filetype on                                           "启用文件类型侦测
filetype plugin on                                    "针对不同的文件类型加载对应的插件
filetype plugin indent on                             "启用缩进
set mouse-=a                                          "禁用鼠标
set smartindent                                       "启用智能对齐方式
set expandtab                                         "将Tab键转换为空格
set tabstop=4                                         "设置Tab键的宽度
set shiftwidth=4                                      "换行时自动缩进4个空格
set softtabstop=4                                     "逢4空格进1制表符
set smarttab                                          "指定按一次backspace就删除shiftwidth宽度的空格
set foldenable                                        "启用折叠
"set foldmethod=indent                                "indent 折叠方式
set foldmethod=marker                                 "marker 折叠方式

"为phthon 设置
"autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4
" 用空格键来开关折叠
"nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>

set autoread                                          " 当文件在外部被修改，自动更新该文件
set ignorecase                                        "搜索模式里忽略大小写
set smartcase                                         "如果搜索模式包含大写字符，不使用 'ignorecase' 选项，只有在输入搜索模式并且打开 'ignorecase' 选项时才会使用
" set noincsearch                                       "在输入要搜索的文字时，取消实时匹配

"创建文件模板
autocmd BufNewFile *.py 0r ~/.vim/template/pythonconfig.py

"}}}
" -----------------------------------------------------------------------------
"  < 界面显示配置 >
" -----------------------------------------------------------------------------
"{{{ 
" 设置代码配色方案
if g:isGUI
    colorscheme desert                                "Gvim配色方案
else
    colorscheme desert                                "终端配色方案
endif
 
" 个性化状栏（这里提供两种方式，要使用其中一种去掉注释即可，不使用反之）
" let &statusline=' %t %{&mod?(&ro?"*":"+"):(&ro?"=":" ")} %1*|%* %{&ft==""?"any":&ft} %1*|%* %{&ff} %1*|%* %{(&fenc=="")?&enc:&fenc}%{(&bomb?",BOM":"")} %1*|%* %=%1*|%* 0x%B %1*|%* (%l,%c%V) %1*|%* %L %1*|%* %P'
" set statusline=%t\ %1*%m%*\ %1*%r%*\ %2*%h%*%w%=%l%3*/%L(%p%%)%*,%c%V]\ [%b:0x%B]\ [%{&ft==''?'TEXT':toupper(&ft)},%{toupper(&ff)},%{toupper(&fenc!=''?&fenc:&enc)}%{&bomb?',BOM':''}%{&eol?'':',NOEOL'}]
  
" 显示/隐藏菜单栏、工具栏、滚动条，可用  F12 切换
if g:isGUI
    "设置隐藏gvim的菜单和工具栏切换
    set guioptions-=m
    set guioptions-=T
    "去除左右两边的滚动条
    set go-=r
    set go-=L
    map <silent> <F12> :if &guioptions =~# 'm' <Bar>
        \set guioptions-=m <Bar>
        \set guioptions-=T <Bar>
        \set guioptions-=r <Bar>
        \set guioptions-=L <Bar>
    \else <Bar>
        \set guioptions+=m <Bar>
        \set guioptions+=T <Bar>
        \set guioptions+=r <Bar>
        \set guioptions+=L <Bar>
    \endif<CR>
endif

set number                                    "显示行号
"set relativenumber                           "相对行号 要想相对行号起作用要放在显示行号后面
set laststatus=2                             "启用状态栏信息
set cmdheight=2                              "设置命令行的高度为2，默认为1
set guifont=Consolas:h11                      "设置字体:字号（字体名称空格用下划线代替）
"set guifont=Inconsolata:h14
"set guifont=Consolas:h10

set cursorline                                "设置光标高亮显
set nowrap                                    "禁止自动换行
"set wrap                                     "自动换行
"set undofile                                 "无限undo
"set guifont=Inconsolata:h12                  "GUI界面里的字体，默认有抗锯齿
set isk+=-                                    "将-连接符也设置为单词
set shortmess=atI                             "去掉欢迎界面
" au GUIEnter * simalt ~x                     "窗口启动时自动最大化
"winpos 100 10                                "指定窗口出现的位置，坐标原点在屏幕左上角
set lines=30 columns=100                      "指定窗口大小，lines为高度，columns为宽度
set linespace=0
set numberwidth=4                             "行号栏的宽度
"set columns=85             "初始窗口的宽度
"set lines=50              "初始窗口的高度
"winpos 620 45             "初始窗口的位置

" 每行超过80个的字符用下划线标示
au BufWinEnter * let w:m2=matchadd('Underlined', '\%>' . 80 . 'v.\+', -1)
"Color Settings {
set colorcolumn=80           "彩色显示第80行
set t_Co=256                 "设置256色显示示
"set cursorcolumn             "光标垂直高亮
set ttyfast
set ruler
set backspace=indent,eol,start
"}

set nocompatible          "不要兼容vi
filetype off              "必须的设置：
set ignorecase "设置大小写敏感和聪明感知(小写全搜，大写完全匹配)
set smartcase
"set gdefault
set incsearch
set hlsearch
" 插入括号时，短暂的跳转到匹配的对应括号，显示匹配的时间由matchtime决定
set showmatch
set matchtime=3             " 单位是十分之一秒
set whichwrap=b,s,<,>,[,]  "让退格，空格，上下箭头遇到行首行尾时自动移到下一行（包括insert模式）
"}}}
" -----------------------------------------------------------------------------
"  < 其它配置 >
" -----------------------------------------------------------------------------
"  {{{
set writebackup                             "保存文件前建立备份，保存成功后删除该备份
set nobackup                                "设置无备份文件
" set noswapfile                              "设置无临时文件
set vb t_vb=                                "关闭提示音
 
"}}}
" -----------------------------------------------------------------------------
"  < Leaders配置 >
" -----------------------------------------------------------------------------
"{{{
"修改leader键为逗号
let mapleader=","
"imap fj <esc>
imap <s-space> <esc>

"配置文件编辑
"nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>ev :e $MYVIMRC<cr>

"折叠html标签 ,fold tag
nnoremap <leader>ft vatzf

"使用<leader>空格来取消搜索高亮
nnoremap <leader><space> :noh<cr>

"文件类型切换
nmap <leader>fj :set ft=javascript<CR>
nmap <leader>fc :set ft=css<CR>
nmap <leader>fh :set ft=html<CR>
nmap <leader>fm :set ft=mako<CR>

" 在不使用 MiniBufExplorer 插件时也可用<C-k,j,h,l>切换到上下左右的窗口中去
noremap <c-k> <c-w>k
noremap <c-j> <c-w>j
noremap <c-h> <c-w>h
noremap <c-l> <c-w>l
"}}}
" -----------------------------------------------------------------------------
"  < 编写文件时的配置 >
" -----------------------------------------------------------------------------
"{{{
autocmd! bufwritepost .vimrc source %        "自动载入配置文件不需要重启
"插入模式Ctrl+jklh下移动光标
inoremap <c-j> <down>
inoremap <c-k> <up>
inoremap <c-h> <left>
inoremap <c-l> <right>
inoremap <c-u> <end>
"inoremap <c-m> <c-o>o    完了 原来cm是enter的本体
"inoremap <c-i> <esc>     完了 原来ci是tab的本体
inoremap (  ()<left>
inoremap [  []<left>
inoremap {  {}<left>
inoremap )  <c-r>=ClosePair(')')<CR>
inoremap ]  <c-r>=ClosePair(']')<CR>
inoremap }  <c-r>=ClosePair('}')<CR>
function! ClosePair(char)
 if getline('.')[col('.') - 1] == a:char
 return "\<Right>"
 else
 return a:char
 endif
endf
inoremap '  <c-r>=ClosePairs("'")<CR>
inoremap "  <c-r>=ClosePairs('"')<CR>
function! ClosePairs(char)
 if getline('.')[col('.') - 1] == a:char
 return "\<Right>"
 else
 return a:char.a:char."\<Esc>i"
 endif
endf

"command! -nargs=0 W b:AutoRefresh()

"}}}
" -----------------------------------------------------------------------------
"  < 编译、连接、运行配置 >
" -----------------------------------------------------------------------------
" {{{
"  F5 运行Python
map <F3> :call PyRun()<CR>
imap <F3> <ESC>:call PyRun()<CR>
func! PyRun()
    exe ":w"
    if expand("%:e") == "py" 
        let  s:ShowWarning = 1 
        let s:LastShellReturn_C = 0
        let v:statusmsg = ''
        redraw!
        exe ":setlocal makeprg=python". escape(expand('%:p'),' ')
        echohl WarningMsg | echo " compiling..."
        silent make
        redraw!
        if v:shell_error != 0
            let s:LastShellReturn_C = v:shell_error
        endif
        if s:LastShellReturn_C != 0
            exe ":bo cope"
            echohl WarningMsg | echo " compilation failed"
        endif
        if s:ShowWarning
            exe ":bo cw"
            echohl WarningMsg | echo " compilation successful"
        endif
    else
        echohl WarningMsg | echo " please choose the correct source file"
    endif
    exe ":setlocal makeprg=make"
endfunc
" 上上上 鄙视自己！！！
 map <F4> <Esc>:!"python.exe" %<CR>

" F9 一键保存、编译、连接存并运行
map <F9> :call Run()<CR>
imap <F9> <ESC>:call Run()<CR>

" Ctrl + F9 一键保存并编译
map <c-F9> :call Compile()<CR>
imap <c-F9> <ESC>:call Compile()<CR>
 
" Ctrl + F10 一键保存并连接
map <c-F10> :call Link()<CR>
imap <c-F10> <ESC>:call Link()<CR>
 
let s:LastShellReturn_C = 0
let s:LastShellReturn_L = 0
let s:ShowWarning = 1
let s:Obj_Extension = '.o'
let s:Exe_Extension = '.exe'
let s:Sou_Error = 0
 
" -fexec-charset=gbk\
let s:windows_CFlags = 'gcc\ -Wall\ -g\ -O0\ -c\ %\ -o\ %<.o'
let s:linux_CFlags = 'gcc\ -Wall\ -g\ -O0\ -c\ %\ -o\ %<.o'
 
let s:windows_CPPFlags = 'g++\ -fexec-charset=gbk\ -Wall\ -g\ -O0\ -c\ %\ -o\ %<.o'
let s:linux_CPPFlags = 'g++\ -Wall\ -g\ -O0\ -c\ %\ -o\ %<.o'
 
func! Compile()
    exe  ":ccl"
    exe ":update"
    if expand("%:e") == "c" || expand("%:e") == "cpp" || expand("%:e") == "cxx"
        let s:Sou_Error = 0
        let s:LastShellReturn_C = 0
        let Sou = expand("%:p")
        let Obj = expand("%:p:r").s:Obj_Extension
        let Obj_Name = expand("%:p:t:r").s:Obj_Extension
        let v:statusmsg = ''
        if !filereadable(Obj) || (filereadable(Obj) && (getftime(Obj) < getftime(Sou)))
            redraw!
            if expand("%:e") == "c"
                if g:iswindows
                    exe ":setlocal makeprg=".s:windows_CFlags
                else
                    exe ":setlocal makeprg=".s:linux_CFlags
                endif
                echohl WarningMsg | echo " compiling..."
                silent make
            elseif expand("%:e") == "cpp" || expand("%:e") == "cxx"
                if g:iswindows
                    exe ":setlocal makeprg=".s:windows_CPPFlags
                else
                    exe ":setlocal makeprg=".s:linux_CPPFlags
                endif
                echohl WarningMsg | echo " compiling..."
                silent make
            endif
            redraw!
            if v:shell_error != 0
                let s:LastShellReturn_C = v:shell_error
            endif
            if g:iswindows
                if s:LastShellReturn_C != 0
                    exe ":bo cope"
                    echohl WarningMsg | echo " compilation failed"
                else
                    if s:ShowWarning
                        exe ":bo cw"
                    endif
                    echohl WarningMsg | echo " compilation successful"
                endif
            else
                if empty(v:statusmsg)
                    echohl WarningMsg | echo " compilation successful"
                else
                    exe ":bo cope"
                endif
            endif
        else
            echohl WarningMsg | echo ""Obj_Name"is up to date"
        endif
    else
        let s:Sou_Error = 1
        echohl WarningMsg | echo " please choose the correct source file"
    endif
    exe ":setlocal makeprg=make"
endfunc
 
func! Link()
    call Compile() 
    if s:Sou_Error || s:LastShellReturn_C != 0
        return
    endif
    let s:LastShellReturn_L = 0
    let Sou = expand("%:p")
    let Obj = expand("%:p:r").s:Obj_Extension
    if g:iswindows
        let Exe = expand("%:p:r").s:Exe_Extension
        let Exe_Name = expand("%:p:t:r").s:Exe_Extension
    else
        let Exe = expand("%:p:r")
        let Exe_Name = expand("%:p:t:r")
    endif
    let v:statusmsg = ''
    if filereadable(Obj) && (getftime(Obj) >= getftime(Sou))
        redraw!
        if !executable(Exe) || (executable(Exe) && getftime(Exe) < getftime(Obj))
            if expand("%:e") == "c"
                setlocal makeprg=gcc\ -o\ %<\ %<.o
                echohl WarningMsg | echo " linking..."
                silent make
            elseif expand("%:e") == "cpp" || expand("%:e") == "cxx"
                setlocal makeprg=g++\ -o\ %<\ %<.o
                echohl WarningMsg | echo " linking..."
                silent make
            endif
            redraw!
            if v:shell_error != 0
                let s:LastShellReturn_L = v:shell_error
            endif
            if g:iswindows
                if s:LastShellReturn_L != 0
                    exe ":bo cope"
                    echohl WarningMsg | echo " linking failed"
                else
                    if s:ShowWarning
                        exe ":bo cw"
                    endif
                    echohl WarningMsg | echo " linking successful"
                endif
            else
                if empty(v:statusmsg)
                    echohl WarningMsg | echo " linking successful"
                else
                    exe ":bo cope"
                endif
            endif
        else
            echohl WarningMsg | echo ""Exe_Name"is up to date"
        endif
    endif
    setlocal makeprg=make
endfunc
 
func! Run()
    let s:Sho wWarning = 0
    call Link()
    let s:ShowWarning = 1
    if s:Sou_Error || s:LastShellReturn_C != 0 || s:LastShellReturn_L != 0
        return
    endif
    let Sou = expand("%:p")
    let Obj = expand("%:p:r").s:Obj_Extension
    if g:iswindows
        let Exe = expand("%:p:r").s:Exe_Extension
    else
        let Exe = expand("%:p:r")
    endif
    if executable(Exe) && getftime(Exe) >= getftime(Obj) && getftime(Obj) >= getftime(Sou)
        redraw! 
        echohl WarningMsg | echo " running..."
        if g:iswindows
            exe ":!%<.exe"
        else
            if  g:isGUI
                exe ":!gnome-terminal -e ./%<"
            else
                exe ":!./%<"
            endif
        endif
        redraw!
        echohl WarningMsg | echo " running finish"
    endif
endfunc
"}}}

" -----------------------------------------------------------------------------
"  < Vundle 插件管理工具配置 >
" -----------------------------------------------------------------------------
" 用于更方便的管理vim插件，具体用法参考 :h vundle 帮助
"{{{
set nocompatible                                      "禁用 Vi 兼容模式
filetype off                                          "禁用文件类型侦测
    "isWin"
    set rtp+=~/.vim/bundle/vundle/
    call vundle#rc()

" 使用Vundle来管理Vundle，这个必须要有。
Bundle 'gmarik/vundle'

"Bundle 'taglist.vim'
" 窗口管理
"Bundle 'winmanager'
" 缓存浏览，跳转
Bundle 'bufexplorer.zip'
" 必不可少，在VIM的编辑窗口树状显示文件目录
Bundle 'The-NERD-tree'
" NERD出品的快速给代码加注释插件，选中，`ctrl+h`即可注释多种语言代码；
Bundle 'The-NERD-Commenter'
" vim自动文档插件 我好像用过比这好的
Bundle 'DoxygenToolkit.vim'
" 围围圈圈不要让我失望啊~
Bundle 'tpope/vim-surround'
" 主题插件
Bundle 'altercation/vim-colors-solarized'
" 状态栏插件
Bundle 'Lokaltog/vim-powerline'
" 语法检查
Bundle 'Syntastic'

"----------------------------------------------
"发现Bundle改成Plugin--------------------------
"----------------------------------------------
"Plugin 'ShowMarks'
"Plugin 'file:///C:/Users/Administrator/.vim/bendi/BoyIn'

"自动补全插件"
Bundle 'snipMate'
"我想让NeoComplCache、SuperTab、SnipMate和谐共存"

"Html Css 插件列表"
" ZenCoding扩展
Bundle 'mattn/emmet-vim'

" -----------------------------------------------------------------------------
"  < TagList 插件配置 >
" -----------------------------------------------------------------------------
" 高效地浏览源码, 其功能就像vc中的workpace
" 那里面列出了当前文件中的所有宏,全局变量, 函数名等
 
" 常规模式下输入 tl 调用插件，如果有打开 Tagbar 窗口则先将其关闭:TagbarClose<cr>
nmap tl :Tlist<cr>
 
let Tlist_Show_One_File=1                   "只显示当前文件的tags
" let Tlist_Enable_Fold_Column=0              "使taglist插件不显示左边的折叠行
let Tlist_Exit_OnlyWindow=1                 "如果Taglist窗口是最后一个窗口则退出Vim
let Tlist_File_Fold_Auto_Close=1            "自动折叠
let Tlist_WinWidth=30                       "设置窗口宽度
let Tlist_Use_Right_Window=1                "在右侧窗口中显示

" -----------------------------------------------------------------------------
"  < WinManager 插件配置 >
" -----------------------------------------------------------------------------
" 管理各个窗口, 或者说整合各个窗口

" 常规模式下输入 F3 调用插件
" nmap <F3> :WMToggle<cr>
nmap wm :WMToggle<cr>

" 这里可以设置为多个窗口, 如'FileExplorer|TagList'
let g:winManagerWindowLayout='FileExplorer'

let g:persistentBehaviour=0                 "只剩一个窗口时, 退出vim
let g:winManagerWidth=30                    "设置窗口宽度

" -----------------------------------------------------------------------------
"  < bufexplorer 插件配置 >
" -----------------------------------------------------------------------------
" ,tab ,be  ,bufexplorer
nmap <leader><tab> :BufExplorer<CR>
 
" -----------------------------------------------------------------------------
"  < The-NERD 插件配置 >
" -----------------------------------------------------------------------------
" 有目录村结构的文件浏览插件
 "Bundle 'The-NERD-tree'
  "设置相对行号
"  nmap <leader>nt :NERDTree<cr>:set rnu<cr>
"  let NERDTreeShowBookmarks=1
"  let NERDTreeShowFiles=1
"  let NERDTreeShowHidden=1
"  let NERDTreeIgnore=['\.$','\~$']
"  let NERDTreeShowLineNumbers=1
"  let NERDTreeWinPos=1

" 常规模式下输入 F2 调用插件
nmap <F2> :NERDTreeToggle<CR>
nmap <leader>nt :NERDTreeToggle<CR>

"Bundle 'The-NERD-Commenter'
"  let NERDShutUp=1
  "支持单行和多行的选择，//格式
"  map <c-h> ,c<space>

" -----------------------------------------------------------------------------
"  < DoxygenToolkit.vim 插件配置 >
" -----------------------------------------------------------------------------
let g:DoxygenToolkit_briefTag_pre="@Synopsis  "
let g:DoxygenToolkit_paramTag_pre="@Param "
let g:DoxygenToolkit_returnTag="@Returns   "
let g:DoxygenToolkit_blockHeader="--------------------------------------------------------------------------"
let g:DoxygenToolkit_blockFooter="----------------------------------------------------------------------------"
let g:DoxygenToolkit_authorName="BoyInWindows@xxx.com"
let g:DoxygenToolkit_licenseTag="My own license 我的版权 Copyright(c)"   
""<-- !!! Does not end with \"\<enter>"

" -----------------------------------------------------------------------------
"  < tpope/vim-surround 插件配置 >
" -----------------------------------------------------------------------------
" 这个还是不太会用！~~~

" -----------------------------------------------------------------------------
"  < altercation/vim-colors-solarized 插件配置 >
" -----------------------------------------------------------------------------
" 这是个主题插件
  colorscheme solarized
  set background=dark                          "使用color solarized
  let g:solarized_termtrans  = 1
  let g:solarized_termcolors = 256
  let g:solarized_contrast   = 'high'
  let g:solarized_visibility = 'high'
  call togglebg#map("<F5>")

" -----------------------------------------------------------------------------
"  <  Lokaltog/vim-powerline 插件配置 >
" -----------------------------------------------------------------------------
" 
 "set laststatus=2
 "set t_Co=256
 let g:Powerline_symblos = 'unicode'
 "set encoding=utf8

" -----------------------------------------------------------------------------
"  < mattn/emmet 插件配置 >
" -----------------------------------------------------------------------------
" ZenCoding 扩展

" 插入模式下 Ctrl+, 使用emment
"  let g:user_emmet_leader_key='<C-y>'

" -----------------------------------------------------------------------------
"  <  插件配置 >
" -----------------------------------------------------------------------------
" 
"}}}
"放置在Bundle的设置后，防止意外BUG
filetype plugin indent on
syntax on
