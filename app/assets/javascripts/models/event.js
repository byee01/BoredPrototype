// Events model

var Event = Backbone.Model.extend({
  url : function() {
    var base = 'events';
    if (this.isNew()) return base;
    return base + (base.charAt(base.length - 1) == '/' ? '' : '/') + this.id;
  }
});
