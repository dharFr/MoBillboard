(function() {
  var BillBoardModel, HomeController, HomeView, app;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  }, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  app = {
    activePage: function() {
      return $('.ui-page-active');
    },
    getLocation: function(success, error) {
      if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(success, error);
      } else {
        error("Geolocation is not supported");
      }
    },
    reapplyStyles: function(el) {
      el.find('ul[data-role]').listview();
      el.find('div[data-role="fieldcontain"]').fieldcontain();
      el.find('a[data-role="button"], button[data-role="button"]').button();
      el.find('input,textarea').textinput();
      return el.page();
    }
  };
  BillBoardModel = (function() {
    __extends(BillBoardModel, Backbone.Model);
    function BillBoardModel() {
      BillBoardModel.__super__.constructor.apply(this, arguments);
    }
    BillBoardModel.prototype.getName = function() {
      return this.get('name');
    };
    BillBoardModel.prototype.getNotes = function() {
      return this.get('boardNotes');
    };
    BillBoardModel.prototype.getAdress = function() {
      return [this.get('position').address.streetNumber, this.get('position').address.street, this.get('position').address.city].join(", ");
    };
    return BillBoardModel;
  })();
  HomeView = (function() {
    __extends(HomeView, Backbone.View);
    function HomeView(billboard) {
      this.render = __bind(this.render, this);      HomeView.__super__.constructor.apply(this, arguments);
      this.el = app.activePage();
      this.billboard = billboard;
      this.template = _.template('<div class="homeview">\n	<a href="#chooseVenue" data-icon="arrow-r" data-iconpos="right" data-role="button">\n		<span class="name"><%= billboard.getName() %></span> :: \n		<span class="adress"><%= billboard.getAdress() %></span>\n	</a>\n	<ul data-role="listview" data-theme="c" data-filter="false">\n		<% _.each(billboard.getNotes(), function(boardNote) { %>\n			<li><a href="#boardNotes-<%= boardNote.id %>"><%= boardNote.getTitle() %></a></li>\n		<% }); %>\n	</ul>\n</div>');
      this.render();
    }
    HomeView.prototype.render = function() {
      this.el.find('.ui-content').html(this.template({
        billboard: this.billboard
      }));
      return app.reapplyStyles(this.el);
    };
    return HomeView;
  })();
  HomeController = (function() {
    var geoError, geoSuccess;
    __extends(HomeController, Backbone.Router);
    HomeController.prototype.routes = {
      "home": "home"
    };
    geoSuccess = function(self) {
      return function(position) {
        var _base;
        self.position = position;
        console.log("geoLoc success", self.position);
        self._billboard = new BillBoardModel({
          name: "Fake Name/Real position",
          position: position,
          boardNotes: {}
        });
        return (_base = self._views)['home'] || (_base['home'] = new HomeView(self._billboard));
      };
    };
    geoError = function(self) {
      return function(msg) {
        console.log("geo error", msg);
        alert("TODO: handle geoloc Error");
      };
    };
    function HomeController() {
      HomeController.__super__.constructor.apply(this, arguments);
      this._billboard;
      this._views = {};
    }
    HomeController.prototype.home = function() {
      return app.getLocation(geoSuccess(this), geoError(this));
    };
    return HomeController;
  })();
  app.homeController = new HomeController();
  $(document).ready(function() {
    Backbone.history.start();
    return app.homeController.home();
  });
  this.app = app;
}).call(this);
