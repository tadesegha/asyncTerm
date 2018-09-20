if exists('s:bufferId')
  unlet s:bufferId
endif

function! s:AsyncTerm()
  call s:SelectWindowForTerminal()
  call s:StartOrLoadTerminal()
endfunction

function! s:SelectWindowForTerminal()
  let command = (len(nvim_list_wins()) == 1) ? 'vsplit' : 'wincmd b'
  execute command
endfunction

function! s:StartOrLoadTerminal()
  if exists('s:bufferId')
    call s:LoadTerminal()
  else
    call s:NewTerminal()
  endif
endfunction

function! s:LoadTerminal()
  if bufexists(s:bufferId)
    execute 'buffer ' . s:bufferId
  else
    unlet s:bufferId
    call s:AsyncTerm()
  endif
endfunction

function! s:NewTerminal()
  let shell = exists('g:asyncTermShell') ? g:asyncTermShell : &shell
  enew
  let s:jobId = termopen(shell)
  let s:bufferId = bufnr('%')
endfunction

function! s:AsyncTermExecute(cmd)
  call s:AsyncTerm()
  call chansend(s:jobId, a:cmd . "\r")
  execute 'normal G'
  wincmd p
endfunction

command! AsyncTerm call s:AsyncTerm() | startinsert
command! -nargs=+ AsyncTermExecute call s:AsyncTermExecute('<args>')
