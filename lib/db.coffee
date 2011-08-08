
mongo = require('mongoskin')

db = null


module.exports = {
  init: (config) ->
    db = mongo.db(config.url)

  db: () ->
    return db
}



