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
		return {
			command = "mysql",
			args = {
				'--table',
				'-u',
				config.user,
				'-h',
				config.host,
				'-e',
				query,
				config.database,
			},
		}
	end
end

return connectors
