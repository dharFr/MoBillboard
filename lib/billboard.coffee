
db = require('./db').db()

db.bind('billboards')

class Billboard
  @findByPlaceId: (placeId, callback) ->
    db.billboards.findOne({"place.id": placeId}, {}, callback)

  @get: (billboardId, callback) ->
    db.billboards.findById(billboardId, {}, callback)

  @create: (place, callback) ->
    db.billboards.insert(place, {}, callback)


module.exports.Billboard = Billboard


