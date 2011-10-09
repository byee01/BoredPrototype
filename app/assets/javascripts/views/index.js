// Index view for events

//= require backbone

App.Views.Index = Backbone.View.extend({
  initialize: function() {
      this.events = this.options.events;
      this.render(); 
  },

  render: function() {
    if(this.events.length > 0) {
      out = this.events;    
    } else {
      out = "<h3>No events.</h3>";
    }
    console.log(out);
  }
});
