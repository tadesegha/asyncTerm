function! s:Term()
    if exists('s:bufferId') && bufexists(s:bufferId)
        execute "buffer " . s:bufferId
    else
        call s:NewTerm()
    endif
endfunction

function! s:NewTerm()
    enew
    let shell = exists('g:termShell') ? g:termShell : &shell
    let s:jobId = termopen(shell)
    let s:bufferId = bufnr("%")
endfunction

command! Term call s:Term() | startinsert
command! NewTerm call s:NewTerm() | startinsert
