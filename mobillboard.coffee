

# Module dependencies.

express = require('express')
require('express-resource')

config = require('./config')

mongoUrl = process.env.MONGOLAB_URI || "localhost:27017/mobillboard"

mongoUrl = mongoUrl + '?auto_reconnect'

console.log "Using mongo URL #{mongoUrl}"

# init DB
require('./lib/db').init(mongoUrl)

# init modules
require('./lib/places').init(config.foursquare)

# Configuration
app = module.exports = express.createServer()


app.configure(() ->
  app.set('views', __dirname + '/views')
  app.set('view engine', 'jade')
  app.use(express.bodyParser())
  app.use(express.methodOverride())
  app.use(app.router)
  app.use(express.static(__dirname + '/public'))
)

app.configure('development', () ->
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true }))
)

app.configure('production', () ->
  app.use(express.errorHandler())
)

# Routes

app.get('/', (req, res) ->
  res.render('index', {
    title: 'MoBillboard'
  })
)

app.resource("billboards", require('./resources/billboards'), { format: 'json' })

