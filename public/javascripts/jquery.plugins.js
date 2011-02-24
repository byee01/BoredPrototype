(function($){
  $.fn.shuffle = function() {
    return this.each(function(){
      var items = $(this).children();
      return (items.length)
        ? $(this).html($.shuffle(items))
        : this;
    });
  }
 
  $.shuffle = function(arr) {
    for(
      var j, x, i = arr.length; i;
      j = parseInt(Math.random() * i),
      x = arr[--i], arr[i] = arr[j], arr[j] = x
    );
    return arr;
  }
})(jQuery);


$.fn.imagesLoaded = function(callback){
  var elems = this.find('img'),
      len   = elems.length,
      _this = this;
  
  if ( !elems.length ) {
    callback.call( this );
  }

  elems.bind('load',function(){
    if (--len <= 0){ 
      callback.call( _this ); 
    }
  }).each(function(){
    // cached images don't fire load sometimes, so we reset src.
    if (this.complete || this.complete === undefined){
      var src = this.src;
      // webkit hack from http://groups.google.com/group/jquery-dev/browse_thread/thread/eee6ab7b2da50e1f
      // data uri bypasses webkit log warning (thx doug jones)
      this.src = "data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///ywAAAAAAQABAAACAUwAOw==";
      this.src = src;
    }  
  }); 

  return this;
};
