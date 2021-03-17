local util = require('query_nvim/util')

local connectors = {}

function connectors.mysql(config)
	if config.user == nil then
		error("connectors.mysql, config.user was not provided")
	end

	if config.host == nil then
		error("connectors.mysql, config.host was not provided")
	end

	if config.database == nil then
		error("connectors.mysql, config.database was not provided")
	end

	return function(query)
		local options = {
			'--table',
		}

		local user = {
			'-u',
			config.user,
		}

		local password = {}
		if config.password ~= nil then
			password = {
				"-p"..config.password
			}
		end

		local host = {
			'-h',
			config.host,
		}

		local db_query = {
			'-e',
			query,
			config.database,
		}

		local args = util.concat_tables(options, user, password, host, db_query)

		return {
			command = "mysql",
			args = args
		}
	end
end

return connectors
