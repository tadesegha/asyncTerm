function! s:Term()
    if exists('s:bufferId') && bufexists(s:bufferId)
        execute "buffer " . s:bufferId
    else
        call s:NewTerm('shell', 1)
    endif
endfunction

function! s:NewTerm(name, track)
    enew
    let shell = exists('g:termShell') ? g:termShell : &shell
    let s:jobId = termopen(shell)

    if (a:track)
      let s:bufferId = bufnr("%")
    endif

    execute "file " . a:name
endfunction

command! Term call s:Term() | startinsert
command! -nargs=1 NewTerm call s:NewTerm("<args>", 0) | startinsert
