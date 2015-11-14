" load guard {{{1

if exists('g:autoloaded_read')
  finish
endif
let g:autoloaded_read = 1

" }}}
" opfunc() {{{1

function! s:opfunc(type) abort
  let sel_save = &selection
  let cb_save = &clipboard
  let reg_save = @@
  try
    set selection=inclusive clipboard-=unnamed clipboard-=unnamedplus
    if a:type =~ '^\d\+$'
      silent exe 'normal! ^v'.a:type.'$hy'
    elseif a:type =~# '^.$'
      silent exe "normal! `<" . a:type . "`>y"
    elseif a:type ==# 'line'
      silent exe "normal! '[V']y"
    elseif a:type ==# 'block'
      silent exe "normal! `[\<C-V>`]y"
    else
      silent exe "normal! `[v`]y"
    endif
    redraw
    return @@
  finally
    let @@ = reg_save
    let &selection = sel_save
    let &clipboard = cb_save
  endtry
endfunction

" }}}
" read#stop() {{{1

" stops reading (if running)
function! read#stop()
  " if read command is still running
  if exists('s:pid') && len(system('ps -p '.s:pid.' -o "command" | grep ^'.g:read_cmd))
    call system('kill -9 '.s:pid)
  endif
endfunction

" }}}
" read#filterop() {{{1

function! read#filterop(type) abort
    let execCmd = split(g:read_cmd)[0]
  if !executable(execCmd)
    echohl ErrorMSG | echo execCmd.' executable not found!' | echohl NONE
    return
  endif
  try
    let command = g:read_cmd
    
    " replace language with system language
    let command = substitute(command, "%{language}", g:read_language, "")

    " let expr = s:get_visual_selection()
    let expr = substitute(s:opfunc(a:type), "\n", " ", "g")

    " replace ~, !, @, #, $, %, &, *, (, ), -, _, +, =, {, }, [, ], ?, /
    let expr = substitute(expr , "\\~" , g:read_tilde_text           , "g")
    let expr = substitute(expr , "!"   , g:read_bang_text            , "g")
    let expr = substitute(expr , "@"   , g:read_at_text              , "g")
    let expr = substitute(expr , "#"   , g:read_crunch_text          , "g")
    let expr = substitute(expr , "\\$" , g:read_dollar_text          , "g")
    let expr = substitute(expr , "%"   , g:read_percent_text         , "g")
    let expr = substitute(expr , "&"   , g:read_ampersand_text       , "g")
    let expr = substitute(expr , "*"   , g:read_star_text            , "g")

    let expr = substitute(expr , "-"   , g:read_minus_text           , "g")
    let expr = substitute(expr , "_"   , g:read_underscore_text      , "g")
    let expr = substitute(expr , "="   , g:read_equals_text          , "g")
    let expr = substitute(expr , "+"   , g:read_plus_text            , "g")

    let expr = substitute(expr , "?"   , g:read_question_text        , "g")
    let expr = substitute(expr , "\""  , g:read_quote_text           , "g")
    let expr = substitute(expr , "'"  , g:read_smallQuote_text      , "g")
    let expr = substitute(expr , "?"   , g:read_question_text        , "g")
    let expr = substitute(expr , "/"   , g:read_slash_text           , "g")
    let expr = substitute(expr , "\\." , g:read_dot_text             , "g")
    let expr = substitute(expr , "|"   , g:read_pipe_text            , "g")

    " braces too much?
    let expr = substitute(expr , "("   , g:read_opening_bracket_text , "g")
    let expr = substitute(expr , ")"   , g:read_closing_bracket_text , "g")
    let expr = substitute(expr , "{"   , g:read_opening_curl_text    , "g")
    let expr = substitute(expr , "}"   , g:read_closing_curl_text    , "g")
    let expr = substitute(expr , "["   , g:read_opening_brace_text   , "g")
    let expr = substitute(expr , "]"   , g:read_closing_brace_text   , "g")
    let expr = substitute(expr , ";"   , g:read_semicolon_text       , "g")
    let expr = substitute(expr , ":"   , g:read_colon_text           , "g")
    
    " echo expr
    " return
    
    "replace spaces with %20
    let expr = substitute(expr , " ", "%20", "g")
    

    " replace text
    let command = substitute(command, '%{text}', shellescape(expr), "")

    call read#stop()

    let pid = system(command)
    let s:pid = substitute(pid, "\n", "", "")
  catch /^.*/
    echohl ErrorMSG | echo v:errmsg | echohl NONE
  endtry
endfunction

" }}}

" good stuff from xolox (http://stackoverflow.com/questions/1533565/how-to-get-visually-selected-text-in-vimscript)
" function! s:get_visual_selection()
"   " Why is this not a built-in Vim script function?!
"   let [lnum1, col1] = getpos("'<")[1:2]
"   let [lnum2, col2] = getpos("'>")[1:2]
"   let lines = getline(lnum1, lnum2)
"   let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
"   let lines[0] = lines[0][col1 - 1:]
"   return join(lines, " ")
" endfunction

" vim:set ft=vim et sw=2:
