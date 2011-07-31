#
# main app
#
app =
	activePage: ->
		$('.ui-page-active')
	
	getLocation: (success, error)->

		if navigator.geolocation
			navigator.geolocation.getCurrentPosition(success, error)
		else
			error("Geolocation is not supported")
		return
	
	reapplyStyles: (el) ->
		el.find('ul[data-role]').listview()
		el.find('div[data-role="fieldcontain"]').fieldcontain()
		el.find('a[data-role="button"], button[data-role="button"]').button()
		el.find('input,textarea').textinput()
		el.page()

class BillBoardModel extends Backbone.Model
	
	getName: ->
		@get('name')
	
	getNotes: ->
		@get('boardNotes')
	
	getAdress: ->
		[@get('position').address.streetNumber, @get('position').address.street, @get('position').address.city].join(", ") 

class HomeView extends Backbone.View
	constructor: (billboard) ->
		super

		@el = app.activePage()
		@billboard = billboard

		@template = _.template('''
		<div class="homeview">
			<a href="#chooseVenue" data-icon="arrow-r" data-iconpos="right" data-role="button">
				<span class="name"><%= billboard.getName() %></span> :: 
				<span class="adress"><%= billboard.getAdress() %></span>
			</a>
			<ul data-role="listview" data-theme="c" data-filter="false">
				<% _.each(billboard.getNotes(), function(boardNote) { %>
					<li><a href="#boardNotes-<%= boardNote.id %>"><%= boardNote.getTitle() %></a></li>
				<% }); %>
			</ul>
		</div>
		''')

		@render()

	render: =>
		@el.find('.ui-content').html(@template billboard: @billboard)

		# A hacky way of reapplying the jquery mobile style
		app.reapplyStyles(@el)

class HomeController extends Backbone.Router
	routes :
		"home" : "home"
	
	# private functions
	geoSuccess = (self) ->
		(position) ->
			self.position = position
			console.log "geoLoc success", self.position

			self._billboard = new BillBoardModel(
				name: "Fake Name/Real position"
				position: position
				boardNotes: {}
			)
			self._views['home'] ||= new HomeView(self._billboard)
	
	geoError = (self) ->
		(msg) ->
			console.log "geo error", msg
			alert "TODO: handle geoloc Error"
			return

	# public methods
	constructor: ->
		super
		@_billboard
		@_views = {}

	home: ->
		app.getLocation( geoSuccess(@), geoError(@) )

app.homeController = new HomeController()

#
# Start the app
#

$(document).ready ->
	Backbone.history.start()
	app.homeController.home()

@app = app
