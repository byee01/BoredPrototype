$(document).ready(function(){
	$('#new_event').hide();
	$('#new_event_btn').click(function(){
		$('#new_event').fadeIn();
		clear_form_elements('#new_event form');
	});

	     $('#event-1').click(function(e) {
		e.preventDefault();
		$('#event-1-desc').reveal();	
     });

});


function clear_form_elements(ele) {

    $(ele).find(':input').each(function() {
        switch(this.type) {
            case 'password':
            case 'select-multiple':
            case 'select-one':
            case 'text':
			case 'file':
            case 'textarea':
                $(this).val('');
                break;
            case 'checkbox':
            case 'radio':
                this.checked = false;
        }
    });

}

$('#events').masonry({ columnWidth: 240, animate: true });   
		 var
		  speed = 500,  // animation speed
		  $wall = $('#events')
		  // $wall = $('#events').find('.wrap')
		;

		$wall.masonry({
		  columnWidth: 240, 
		  // only apply masonry layout to visible elements
		  itemSelector: '.box:not(.invis)',
		  animate: true,
		  animationOptions: {
			duration: speed,
			queue: false
		  }
		});
		// This is an on-click hander for all the links in the menu bar.
		$('#filtering-nav a').click(function(){
		  var colorClass = '.' + $(this).attr('class');

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