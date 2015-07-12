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
	dbhost = process.env.MONGOHOST || process.env.MONGODB_PORT_27017_TCP_ADDR ||  "localhost"
	dbport = process.env.MONGOPORT || process.env.MONGODB_PORT_27017_TCP_PORT || 27017
	dbuser = process.env.MONGOUSER || undefined
	dbpass = process.env.MONGOPASS || undefined
	dbcontainer = process.env.MONGOCONTAINER || "dev"

mongo = require 'mongodb-wrapper'

exports.dbhandler = (callback) ->
	console.log "Host=" + dbhost + "; port=" + dbport
	callback(mongo.db(dbhost, parseInt(dbport), dbcontainer, '', dbuser, dbpass))

exports.ObjectID = mongo.ObjectID
