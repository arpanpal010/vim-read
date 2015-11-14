if exists('g:loaded_read') && g:loaded_read
  finish
endif
let g:loaded_read = 1

let s:save_cpo = &cpo
set cpo&vim

"Thank you Google and Stackoverflow.com!!
if !exists('g:read_cmd')
  let g:read_cmd='mpv "http://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&tl=%{language}&q=%{text}" & echo $!'
endif

" set language
if !exists('g:read_language')
    let locale = system('echo ${LANG%_*}')
    if locale 
        let g:read_language = substitute(locale, "\n", "", "")
    else 
        let g:read_language = "en"
    endif
endif

" FIXME : put proper names of signs
if !exists('g:read_tilde_text')           | let g:read_tilde_text           = " tilde "           | endif
if !exists('g:read_bang_text')            | let g:read_bang_text            = " bang "            | endif
if !exists('g:read_at_text')              | let g:read_at_text              = " at "              | endif
if !exists('g:read_crunch_text')          | let g:read_crunch_text          = " hash "            | endif
if !exists('g:read_dollar_text')          | let g:read_dollar_text          = " dollar "          | endif
if !exists('g:read_percent"_text')        | let g:read_percent_text         = " percent "         | endif
if !exists('g:read_ampersand_text')       | let g:read_ampersand_text       = " ampersand "       | endif
if !exists('g:read_star_text')            | let g:read_star_text            = " star "            | endif

if !exists('g:read_minus_text')           | let g:read_minus_text           = " minus "           | endif
if !exists('g:read_underscore_text')      | let g:read_underscore_text      = " underscore "      | endif
if !exists('g:read_equals_text')          | let g:read_equals_text          = " equals "          | endif
if !exists('g:read_plus_text')            | let g:read_plus_text            = " plus "            | endif

if !exists('g:read_question_text')        | let g:read_question_text        = " question "        | endif
if !exists('g:read_quote_text')           | let g:read_quote_text           = " quote "           | endif
if !exists('g:read_smallQuote_text')      | let g:read_smallQuote_text      = " smallquote "      | endif
if !exists('g:read_slash _text')          | let g:read_slash_text           = " slash "           | endif
if !exists('g:read_dot_text')             | let g:read_dot_text             = " dot "             | endif
if !exists('g:read_pipe_text')            | let g:read_pipe_text            = " pipe "            | endif

" too much noise
if !exists('g:read_opening_bracket_text') | let g:read_opening_bracket_text = " opening-bracket " | endif
if !exists('g:read_closing_bracket_text') | let g:read_closing_bracket_text = " closing-bracket " | endif
if !exists('g:read_opening_curl_text')    | let g:read_opening_curl_text    = " opening-curl "    | endif
if !exists('g:read_closing_curl_text')    | let g:read_closing_curl_text    = " closing-curl "    | endif
if !exists('g:read_opening_brace_text')   | let g:read_opening_brace_text   = " opening-brace "   | endif
if !exists('g:read_closing_brace_text')   | let g:read_closing_brace_text   = " closing-brace "   | endif
if !exists('g:read_semicolon_text')       | let g:read_semicolon_text       = " semicolon "       | endif
if !exists('g:read_colon_text')           | let g:read_colon_text           = " colon "           | endif

nnoremap <silent> <Plug>Read :<C-U>set opfunc=read#filterop<CR>g@
nnoremap <silent> <Plug>StopReading :<C-U>call read#stop()<CR>
xnoremap <silent> <Plug>Read :<C-U>call read#filterop(visualmode())<CR>

nmap yr <Plug>Read
nmap yrr <Plug>Read_
nmap yrs <Plug>StopReading
xmap <C-R> <Plug>Read
vmap <C-R> <Plug>Read

augroup VimRead
  autocmd!
  autocmd VimLeave * call read#stop()
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set ft=vim et sw=2:
