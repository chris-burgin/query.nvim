local connectors = {}

function connectors.mysql(db, query)
	return {
		'--table',
		'-u',
		'root',
		'-h',
		db.host,
		'-e',
		query,
		db.database,
	}
end

return connectors
