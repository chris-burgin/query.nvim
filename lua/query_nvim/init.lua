local util = require('query_nvim/util')

local query_nvim = {}
query_nvim.opts = {}

function query_nvim.run_query(query)
	local lines = {};

	util.run_job({
		command = 'mysql',
		args = {
			'--table',
			'-u',
			'root',
			'-h',
			query_nvim.opts.db.host,
			'-e',
			query,
			query_nvim.opts.db.database,
		},
		on_stdout = vim.schedule_wrap(function (_, line)
			table.insert(lines, line)
		end),
		on_stderr = function (_, data)
			table.insert(lines, data)
		end,
		on_exit = vim.schedule_wrap(function()
			util.create_query_result_buf(lines)
		end),
	})
end

function query_nvim.run_query_on_selection()
	local query = util.get_query(query_nvim.opts);
	query_nvim.run_query(query)
end;

function query_nvim.run_query_on_selection_r(args)
	local replacements = util.split_on_space(args)
	local query = util.get_query(query_nvim.opts);

	for _, replacement in ipairs(replacements) do
		query = query:gsub("?", replacement)
	end

	query_nvim.run_query(query)
end;

function query_nvim.runner(cmd, ...)
	local args = {...}

	if cmd == "query" then
		query_nvim.run_query(util.join(args))
		return
	end

	if cmd == "visual" then
		query_nvim.run_query_on_selection()
		return
	end

	if cmd == "visual_r" then
		query_nvim.run_query_on_selection_r(util.join(args))
		return
	end
end

function query_nvim.setup(opts)
	if opts == nil then
		error("opts where not provided to query_nvim.setup")
	end

	if opts.query_buf == nil then
		opts.query_buf = "="
	end

	if opts.db == nil then
		error("opts.db was not provided to query_nvim.setup")
	end

	if opts.db.host == nil then
		error("opts.db.host was not provided to query_nvim.setup")
	end

	if opts.db.database == nil then
		error("opts.db.database was not provided to query_nvim.setup")
	end

	query_nvim.opts = opts;
end

return query_nvim
