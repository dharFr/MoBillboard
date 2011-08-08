
Billboard = require('../lib/billboard').Billboard
places = require('../lib/places')


module.exports = {
  create: (req, res) ->
    Billboard.findByPlaceId(req.body.placeId, (err, existing) ->
      if not existing
        places.get(req.body.placeId, (place) ->
          if place
            Billboard.create(place, (err, inserted) ->
              res.send(inserted)
            )
          else
            res.send(404)
        )
      else #Conflict
        res.send(existing, 409)
    )

  show: (req, res) ->
    console.log req
    Billboard.get(req.params.billboard, (err, data) ->
      #TODO gestion erreurs
      if err
        res.send(err, 500)
      else
        if data
          res.send(data)
        else
          res.send(404)
    )
}


