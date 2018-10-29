let s:returnChar = has("win32") || has("win64") ? "\r" : "\n"
let s:terminals = {  }

function! term#defaultTerm()
  if (has_key(s:terminals, 'shell') && bufexists(s:terminals.shell.bufferNumber))
    execute "buffer " . s:terminals.shell.bufferNumber
  else
    call s:newTerm('shell')
  endif
endfunction

function! s:newTerm(identifier)
  enew
  let shell = exists('g:termShell') ? g:termShell : &shell
  let jobId = termopen(shell)

  execute "file " . a:identifier
  let s:terminals[a:identifier] = { 'jobId': jobId, 'bufferNumber': bufnr("%") }
endfunction

function! term#asyncTerm(identifier, command)
  if (!has_key(s:terminals, a:identifier))
    call s:newTerm(a:identifier)
  endif

  call chansend(s:terminals[a:identifier].jobId, a:command . s:returnChar)
endfunction

function! term#executeInTerm(identifier, command)
  call term#asyncTerm(a:identifier, a:command)
  execute 'buffer ' . s:terminals[a:identifier].bufferNumber
  startinsert
endfunction
