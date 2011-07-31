
config = require('./config').foursquare


venues = require('node-foursquare')(config).Venues

get = (id, callback) ->
  venues.getVenue(id, null, callback)


module.exports = { "get": get }





