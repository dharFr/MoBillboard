
mongo = require('mongoskin')

db = null


module.exports = {
  init: (url) ->
    db = mongo.db(url)

  db: () ->
    return db
}



