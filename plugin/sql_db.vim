function! s:sql_db_complete(arg,line,pos)
	let l = split(a:line[:a:pos-1], '\%(\%(\%(^\|[^\\]\)\\\)\@<!\s\)\+', 1)

	let n_cmd = "Query"
	let v_cmd = "'<,'>Query"

	let m = index(l, v_cmd)
	let cmd = n_cmd
	if m == 0
   let cmd = v_cmd
	endif

  let n = len(l) - index(l, cmd) - 2
	return luaeval("require('query_nvim').complete_list(_A)", n)
endfunction

command -range=% -nargs=+ -complete=custom,s:sql_db_complete Query lua require('query_nvim').runner(<f-args>)
