local util = require('query_nvim/util')
local connectors = require('query_nvim/connectors')

local query_nvim = {
	connectors = connectors
}
query_nvim.opts = {}

function find_connector(db_name)
	for key, db in pairs(query_nvim.opts.db) do
		if key == db_name then
			return db
		end
	end

	error("No db with the key "..db_name.." provided.")
end

function query_nvim.run_query(db_name, query)
	local lines = {};
	local connector = find_connector(db_name)(query)

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
		error("query_nvim.setup, opts was not provided")
	end

	if opts.query_buf == nil then
		opts.query_buf = "x"
	end

	if opts.db == nil then
		error("query_nvim.setup, opts.db was not provided")
	end

	query_nvim.opts = opts;
end

function query_nvim.complete_list(n)
	if n == 0 then
		return "query\nvisual\nvisual_r"
	end

	if n == 1 then
		local getFirstItem = false;
		if util.table_length(query_nvim.opts.db) == 1 then
			getFirstItem = true;
		end

		local names = {}
		for db_name, _ in pairs(query_nvim.opts.db) do
			if getFirstItem then
				return db_name
			end

			table.insert(names, db_name)
		end
		return util.join(names, "\n")
	end
end

return query_nvim
