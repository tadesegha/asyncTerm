let s:returnChar = has("win32") || has("win64") ? "\r" : "\n"

function! s:Term()
    if exists('s:bufferId') && bufexists(s:bufferId)
        execute "buffer " . s:bufferId
    else
        let newTerm = s:NewTerm('shell')
        let s:bufferId = newTerm['bufferNumber']
    endif
endfunction

function! s:NewTerm(bufferName)
    enew
    let shell = exists('g:termShell') ? g:termShell : &shell
    let jobId = termopen(shell)

    execute "file " . a:bufferName
    return { 'jobId': jobId, 'bufferNumber': bufnr("%") }
endfunction

function! s:AsyncTerm(command, bufferName)
  let newTerm = s:NewTerm(a:bufferName)
  call chansend(newTerm["jobId"], a:command . s:returnChar)
endfunction

command! Term call s:Term() | startinsert
command! -nargs=1 NewTerm call s:NewTerm("<args>") | startinsert
command! -nargs=+ AsyncTerm call s:AsyncTerm(<f-args>)
