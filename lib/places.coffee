
config = require('./config').foursquare

venues = require('node-foursquare')(config).Venues

# Foursquare data cleanup. Returns only interesting fields.
cleanupVenue = (data) ->
  venue = data.venue
  return {
    "place": {
      id: venue.id,
      name: venue.name,
      location: venue.location,
      category: venue.categories[0].name
    }
  }

# Get Place by id.
get = (id, callback) ->
  venues.getVenue(id, null, (error, data) ->
    #TODO error case
    callback(cleanupVenue(data))
  )


module.exports = { "get": get }





