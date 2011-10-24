// Event collection

//= require backbone

var EventStore = Backbone.Collection.extend({
  model: Event,
  url: '/events'  
});
