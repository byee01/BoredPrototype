// Events Router

//= require backbone

App.Routers.Events = Backbone.Router.extend({
  routes: {
    "events/:id"  : "show",
    ""            : "index"
  },

  index: function() {
    $.getJSON('/documents', function(data) {
      if(data) {
        var events = _(data).map(function(i) { return new Event(i); });
        new App.Views.Index({ events: events });
      } else {
        new Error({ message: "Error loading events."});
      }
    });
  }
});
