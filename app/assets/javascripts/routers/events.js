// Events Router

//= require backbone

App.Routers.Events = Backbone.Router.extend({
  routes: {
    "events/:id"  : "show",
    ""            : "index"
  },

  index: function() {
    var events = new EventStore();
    events.fetch({
      success: function() {
        new App.Views.Index({collection: events}); 
      },
      error: function() {
        new Error({message: "Error loading events."});
      }
    });
  }
});
