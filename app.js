
require("coffee-script")

var mobillboard = require("./mobillboard")

var port = process.env.PORT || 3000
mobillboard.listen(port)

console.log("Express server listening on port %d in %s mode",
            mobillboard.address().port,
            mobillboard.settings.env)

