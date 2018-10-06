function! s:AsyncTerm()
    if exists('s:bufferId') && bufexists(s:bufferId)
        execute 'normal gt'
    else
        tabnew
        call s:NewTerminal()
    endif
endfunction

function! s:NewTerminal()
    let shell = exists('g:asyncTermShell') ? g:asyncTermShell : &shell
    let s:jobId = termopen(shell)
    let s:bufferId = bufnr("%")
endfunction

function! s:AsyncTermExecute(cmd)
    call chansend(s:jobId, a:cmd . "\r")
    call s:AsyncTerm()
endfunction

command! AsyncTerm call s:AsyncTerm() | startinsert
command! -nargs=+ AsyncTermExecute call s:AsyncTermExecute('<args>')
