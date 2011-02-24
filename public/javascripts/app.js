/*---------------------------
Modal Dialogues
----------------------------*/
$(document).ready(function() {
     $('#new_event_btn').click(function(e) {
          e.preventDefault();
	  $('#create_event').reveal();
     });
});


/*---------------------------
 Scroll function
----------------------------*/

$('#scrollDownBtn').live('click', function(e) {
	e.preventDefault();
	$('html, body').animate({"scrollTop": $('body').scrollTop() + 0.5*$(window).height()});
});

/*---------------------------
 Cycle functions
----------------------------*/

currentPage = 4;

function decreaseCategory(){
	if (currentPage > 1)
		currentPage--;
	$('.col' + currentPage).click();
}

function increaseCategory(){
	if (currentPage < 4)
		currentPage++;
	if(currentPage == 4)
		$('.all').click();
	else
		$('.col' +currentPage).click();
}

/*---------------------------
 Masonry
----------------------------*/

$('#events').imagesLoaded( function(){

	 var
	  speed = 200,  // animation speed
	  $wall = $('#events')
	;
	
	$('#events').masonry({
	  columnWidth: 240, 
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

	  console.log($('body').scrollTop()+$(window).height());

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
		rules: {
			"event[name]": {required:true},
			"event[description]": {required:true},
			"event[location]": {required:true},
			"event[categories][]":{required: true, maxlength: 2}
		}
		
	});
	
});