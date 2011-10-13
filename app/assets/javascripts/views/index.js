// Index view for events

//= require backbone

App.Views.Index = Backbone.View.extend({
  initialize: function() {
    _.bindAll(this, 'render');
    this.model.bind('change', this.render);
    this.render(); 
  },

  render: function() {
    if(this.events.length > 0) {
      console.log("Rendering events index");
      out = this.events;    
    } else {
      out = "<h3>No events.</h3>";
    }
    console.log(out);
  }
});
