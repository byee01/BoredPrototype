// Event collection

//= require backbone

var Events = Backbone.Collection.extend({
  model: Event,
  url: '/events'  
});
