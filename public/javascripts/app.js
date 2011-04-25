/*---------------------------
Related Events
-----------------------------*/

$('div.related_event').live('click', function() {
	var relatedEvent = $(this).parent().attr('class');
	/* Close current event */
	$('div.reveal-modal-bg').click();

	/* Open related event */
	$("#event-" + relatedEvent).click();

});

/*---------------------------
About Page
-----------------------------*/

$('#about').click(function(e) {
	e.preventDefault();
	$('#about_page').reveal();
});


/*---------------------------
Analytics
-----------------------------*/

/*--------------------------
 Event errors
---------------------------*/

var eventErrors = new Array();

function displayErrors(){
	var s = "";
	for(var item in eventErrors){
		s = s + "<li class='error_message'><p>" + eventErrors[item] + "</p></li>";
	}

	$(".ajax_errors").html(s).fadeIn();
}


/*---------------------------
Box Highlighting
-----------------------------*/

$('#filtering-nav a').hover(
	function() {
		var hoveredClass = "div.box." + $(this).attr('class');
		var hoveredBoxes = $(hoveredClass);
		hoveredBoxes.toggleClass('hl', true);
		hoveredBoxes.not('.hl').toggleClass('.in_a_month', true);
	},
	function() {
		var hoveredClass = "div.box." + $(this).attr('class');
		var hoveredBoxes = $(hoveredClass);
		hoveredBoxes.toggleClass('hl', false)
		hoveredBoxes.not('.hl').toggleClass('.in_a_month', false);
	}
);

/*---------------------------
Form stuff
-----------------------------*/

$('button.event_edit_btn').live('click', function(e){
	e.preventDefault();
	$('#presentable_field_' + $(this).val()).hide();
	$('#editable_field_' + $(this).val()).show();
});

/*---------------------------
 Scroll function (only for Kinect!)
----------------------------*/

$('#scrollDownBtn').live('click', function(e) {
	e.preventDefault();
	$('html, body').animate({"scrollTop": $('body').scrollTop() + 0.5*$(window).height()});
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
	var original = $('#filtering-nav li.select')[0];
	$('#filtering-nav a').click(function(){
		var colorClass = '.' + $(this).attr('class');

		$(original).toggleClass('select');
		$(this).parent().toggleClass('select');
		original = $(this).parent();

		if(colorClass=='.all') {
			// show all hidden boxes
			$wall.children('.invis').toggleClass('invis').stop().fadeIn(speed);
		} else {  
			// hide visible boxes 
			$wall.children().not(colorClass).not('.invis').toggleClass('invis').stop().fadeOut(speed);
			// show hidden boxes
			$wall.children(colorClass+'.invis').toggleClass('invis').stop().fadeIn(speed);
		}

		$wall.masonry();

		return false;
	});
	
	$("#new_event").validate({
		onclick: true,
		errorPlacement: function(error, element){
			error.insertAfter(element.parent());
		},
		rules: {
			"event[name]": {required:true},
			"event[time]" : {required:true},
			"event[description]": {required:true},
			"event[location]": {required:true},
			//"event[categories][]":{required: true, maxlength: 2}
			"event[categories][]" :{
				required: {
					depends: function(element) {
						return $('.check2').size() > 1;
					}
				}
			}
		}
	});	
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
 Replace Forms
----------------------------*/


$("li.cat-radio input:checkbox").checkbox({cls:'jquery-safari-checkbox'});


/*---------------------------
 Date Parsing
----------------------------*/
// Username validation logic
//var parseDate = $('#date_input');

$('input.date_input').keyup(function () {
	// cache the 'this' instance as we need access to it within a setTimeout, where 'this' is set to 'window'
	var t = this; 

	// only run the check if the date has actually changed - also means we skip meta keys
	if (this.value != this.lastValue) {
		// the timeout logic means the ajax doesn't fire with *every* key press, i.e. if the user holds down
		// a particular key, it will only fire when the release the key.
		if (this.timer) clearTimeout(this.timer);

		// show our holding text in the validation message space
		//parseDate.removeClass('error').html('<img src="images/ajax-loader.gif" height="16" width="16" /> gears turning...');

		// fire an ajax request in 1/5 of a second
		this.timer = setTimeout(function () {
			$.ajax({
				type: "GET",
				url: "/date_parse",
				dataType: 'json',
				data: "date=" + t.value,
				success: 	function(data){  
								$('span.date_output').text(data.time_s);
								$('input.hidden_date_input').val(data.time)
							},
				error: 		function(data){ 
								$('span.date_output').text("Oops! Don't understand that!");
							}
			});
		}, 200);

		// copy the latest value to avoid sending requests when we don't need to
		this.lastValue = this.value;
	}
});