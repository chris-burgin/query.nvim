local connectors = {}

function connectors.mysql(db, query)
	return {
		command = "mysql",
		args = {
			'--table',
			'-u',
			'root',
			'-h',
			db.host,
			'-e',
			query,
			db.database,
		},
	}
end

function connectors.redis(_, query)
	return {
		command = "redis-cli",
		args = {
			query,
		},
	}
end

function connectors.get(type)
	if type == "mysql" then
		return connectors.mysql
	end

	if type == "redis" then
		return connectors.redis
	end
end

return connectors
