function! s:sql_db_complete(arg,line,pos)
	let l:commands = ["query", "visual", "visual_r", ]
	return join(commands, "\n")
endfunction

command -range=% -nargs=+ -complete=custom,s:sql_db_complete QUERY lua require('query_nvim').runner(<f-args>)
