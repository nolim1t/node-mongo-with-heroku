if process.env.MONGOHQ_URL != undefined
	mongohq_url = process.env.MONGOHQ_URL
	mongohq_url = mongohq_url.split('mongodb://')[1]
	urlpart = mongohq_url.split('@')
	credentials = urlpart[0]
	connection = urlpart[1]
	dbuser = credentials.split(':')[0]
	dbpass = credentials.split(':')[1]
	dbhost = connection.split(':')[0]
	dbport = connection.split(':')[1].split('/')[0]
	dbcontainer = connection.split(':')[1].split('/')[1]
else
	if process.env.MONGOURI != undefined
		mongouri = require('mongo-uri')
		try
		  uri = mongouri.parse(process.env.MONGOURI)
		catch error
			uri = undefined

		if uri != undefined
			if uri.username == null
				uri.username = undefined
			if uri.password == null
				uri.password = undefined
			if uri.hosts.length == 1
				# Non replica set
				dbhost = uri.hosts[0]
				if uri.ports[0] == null
					dbport = 27017
				else
					dbport = uri.ports[0]
				dbcontainer = uri.database
			else
				hostArray = []
				arrayCount = 0
				dbcontainer = uri.database
				for host in uri.hosts
					if uri.ports[arrayCount] == null
						ports = 27017
					else
						ports = uri.ports[arrayCount]
					to_push = {host: host, port: ports, opts: {}}
					hostArray.push to_push
					arrayCount = arrayCount + 1
				opts = uri.options
				if opts.replicaSet != undefined
					opts.rs_name = opts.replicaSet
			dbuser = process.env.MONGOUSER || uri.username || undefined
			dbpass = process.env.MONGOPASS || uri.password || undefined
	else
		# Otherwise use the old way
		dbhost = process.env.MONGOHOST || process.env.MONGODB_PORT_27017_TCP_ADDR ||  "localhost"
		dbport = process.env.MONGOPORT || process.env.MONGODB_PORT_27017_TCP_PORT || 27017
		dbuser = process.env.MONGOUSER || undefined
		dbpass = process.env.MONGOPASS || undefined
		dbcontainer = process.env.MONGOCONTAINER || "dev"

mongo = require 'mongodb-wrapper'

exports.dbhandler = (callback) ->
	if hostArray != undefined
		#callback({hostArray: hostArray, opts: opts, dbname: dbcontainer, user: dbuser, pass: dbpass})
		callback(mongo.db(hostArray, opts, dbcontainer, '', dbuser, dbpass))
	else
		#callback({host: dbhost, port: dbport, database: dbcontainer, user: dbuser, pass: dbpass})
		callback(mongo.db(dbhost, parseInt(dbport), dbcontainer, '', dbuser, dbpass))

exports.ObjectID = mongo.ObjectID
