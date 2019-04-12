let s:returnChar = has("win32") || has("win64") ? "\r" : "\n"
let s:terminals = {  }

function! term#goToTerm(identifier)
  if s:termExists(a:identifier)
    execute "buffer " . a:identifier
  else
    call s:newTerm(a:identifier)
  endif
endfunction

function! term#asyncTerm(identifier, command)
  if !s:termExists(a:identifier)
    call s:newTerm(a:identifier)
  endif

  call chansend(s:terminals[a:identifier].jobId, a:command . s:returnChar)
endfunction

function! s:newTerm(identifier)
  enew
  let shell = exists('g:termShell') ? g:termShell : &shell
  let jobId = termopen(shell)

  execute "file " . a:identifier
  let s:terminals[a:identifier] = { 'jobId': jobId, 'bufferNumber': bufnr("%") }
endfunction

function! s:executeInTerm(identifier, command)
  call term#asyncTerm(a:identifier, a:command)
  execute 'buffer ' . s:terminals[a:identifier].bufferNumber
  startinsert
endfunction

function! s:termExists(identifier)
  return bufexists(a:identifier)
  " return has_key(s:terminals, a:identifier) && bufexists(s:terminals[a:identifier].bufferNumber)
endfunction
