/*---------------------------
 Scroll function (only for Kinect!)
----------------------------*/

$('#scrollDownBtn').live('click', function(e) {
	e.preventDefault();
	$('html, body').animate({"scrollTop": $('body').scrollTop() + 0.5*$(window).height()});
});


/*---------------------------
 Create Event function
----------------------------*/
$('#create_event_btn').click( function(e) {
	e.preventDefault();
	$('#create_event').reveal();
});

$('#my_events_btn').click(function(e){
	e.preventDefault();
	$('#my_events').reveal();
});
/*---------------------------
 Masonry
----------------------------*/

$('#events').imagesLoaded( function(){

	 var
	  speed = 200,  // animation speed
	  $wall = $('#events')
	;
	
	$('#events').masonry({
	  columnWidth: 220, 
	  // only apply masonry layout to visible elements
	  itemSelector: '.box:not(.invis)',
	  animate: true,
	  animationOptions: {
		duration: 300,
		queue: false
	  }
	});
	// This is an on-click hander for all the links in the menu bar.
	$('#filtering-nav a').click(function(){
	  var colorClass = '.' + $(this).attr('class');
		$(this).toggleClass('active');

	  if(colorClass=='.all') {
		// show all hidden boxes
		$wall.children('.invis').toggleClass('invis').fadeIn(speed);
	  } else {  
		// hide visible boxes 
		$wall.children().not(colorClass).not('.invis').toggleClass('invis').fadeOut(speed);
		// show hidden boxes
		$wall.children(colorClass+'.invis').toggleClass('invis').fadeIn(speed);
	  }
	  $wall.masonry();

	  return false;
	});
	
	$("#new_event").validate({
		onclick: true,
		rules: {
			"event[name]": {required:true},
			"event[description]": {required:true},
			"event[location]": {required:true},
			"event[categories][]":{required: true, maxlength: 2}
			}
		});
	
});