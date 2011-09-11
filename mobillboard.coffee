

# Module dependencies.

express = require('express')

app = module.exports = express.createServer()

# Configuration

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

app.get('/prototype', (req, res) ->
	res.render('prototype', {
		title: 'MoBillboard Prototype'
	})
)

