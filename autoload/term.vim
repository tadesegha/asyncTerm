let s:returnChar = has("win32") || has("win64") ? "\r" : "\n"
let s:terminals = {  }

function! term#defaultTerm()
  if s:termExists('shell')
    execute "buffer " . s:terminals.shell.bufferNumber
  else
    call term#newTerm('shell')
  endif
endfunction

function! term#newTerm(identifier)
  enew
  let shell = exists('g:termShell') ? g:termShell : &shell
  let jobId = termopen(shell)

  execute "file " . a:identifier
  let s:terminals[a:identifier] = { 'jobId': jobId, 'bufferNumber': bufnr("%") }
endfunction

function! term#asyncTerm(identifier, command)
  if !s:termExists(a:identifier)
    call term#newTerm(a:identifier)
  endif

  call chansend(s:terminals[a:identifier].jobId, a:command . s:returnChar)
endfunction

function! term#executeInTerm(identifier, command)
  call term#asyncTerm(a:identifier, a:command)
  execute 'buffer ' . s:terminals[a:identifier].bufferNumber
  startinsert
endfunction

function! s:termExists(identifier)
  return has_key(s:terminals, a:identifier) && bufexists(s:terminals[a:identifier].bufferNumber)
endfunction
