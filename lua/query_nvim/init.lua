local util = require('query_nvim/util')
local connectors = require('query_nvim/connectors')

local query_nvim = {}
query_nvim.opts = {}

function find_db_config(db_name)
	local db_config = nil
	for i, db in pairs(query_nvim.opts.db) do
		if db.name == db_name then
			db_config = db;
			break
		end
	end

	if db_config == nil then
		error("No db with the name "..db_name.." provided.")
	end

	return db_config
end

function query_nvim.run_query(db_name, query)
	local lines = {};
	local db = find_db_config(db_name)
	local connector = connectors.get(db.type)(db, query)

	util.run_job({
		command = connector.command,
		args = connector.args,
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

function query_nvim.run_query_on_selection(db_name)
	local query = util.get_query(query_nvim.opts);
	query_nvim.run_query(db_name, query)
end;

function query_nvim.run_query_on_selection_r(db_name, args)
	local replacements = util.split_on_space(args)
	local query = util.get_query(query_nvim.opts);

	for _, replacement in ipairs(replacements) do
		query = query:gsub("?", replacement, 1)
	end

	query_nvim.run_query(db_name, query)
end;

function query_nvim.runner(cmd, db_name, ...)
	local args = {...}

	if cmd == "query" then
		query_nvim.run_query(db_name, util.join(args))
		return
	end

	if cmd == "visual" then
		query_nvim.run_query_on_selection(db_name)
		return
	end

	if cmd == "visual_r" then
		query_nvim.run_query_on_selection_r(db_name, util.join(args))
		return
	end
end

function query_nvim.setup(opts)
	if opts == nil then
		error("opts where not provided to query_nvim.setup")
	end

	if opts.query_buf == nil then
		opts.query_buf = "x"
	end

	if opts.db == nil then
		error("opts.db was not provided to query_nvim.setup")
	end

	for i, db in pairs(opts.db) do
		if db.name == nil then
			error("opts.db["..i.."].type was not provided to query_nvim.setup")
		end

		if db.type == nil then
			error("opts.db["..i.."].type was not provided to query_nvim.setup")
		end

		if db.host == nil then
			error("opts.db["..i.."].host was not provided to query_nvim.setup")
		end

		if db.database == nil then
			error("opts.db["..i.."].database was not provided to query_nvim.setup")
		end
	end

	query_nvim.opts = opts;
end

function query_nvim.complete_list(n)
	if n == 0 then
		return "query\nvisual\nvisual_r"
	end

	if n == 1 then
		if util.table_length(query_nvim.opts.db) == 1 then
			return query_nvim.opts.db[1].name
		end

		local names = {}
		for _, db in pairs(query_nvim.opts.db) do
			table.insert(names, db.name)
		end
		return util.join(names, "\n")
	end
end

return query_nvim
