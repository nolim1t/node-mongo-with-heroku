node-mongo-with-heroku
======================

How to make node.js mongo library + node.js mongo wrapper play nicely with heroku (the version I'm using anyway)

How to use
----------------------


git submodule add git://github.com/nolim1t/node-mongo-with-heroku.git /app/path/to/submodule

or 

git submodule init
git submodule update

How to use in code
----------------------
The directory before the submodule should be used like this

```coffeescript
mongolib = require('./mongo/mongo.coffee')

exports.dbhandler = mongolib.dbhandler

exports.ObjectID = mongolib.ObjectID
```
