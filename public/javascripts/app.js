/*---------------------------
 Bogus data generation
----------------------------*/

var numEvents = 50;
var possibleEvents = [
	{url:'axo.jpg', title:'Alpha Chi Omega Vera Bradley Sale', date:'Wednesday, Feb. 9'},
	{url:'cit.jpg', title:'CIT Ball', date:'Friday, Feb. 18'},
	{url:'disogni.jpg', title:'Disogni - Opening Reception', date:'Sunday, Mar. 5'},
	{url:'help.jpg', title:'"Help Yourself" Resource Fair', date:'Monday, Feb. 14'},
	{url:'isu.jpg', title:'ISU Valentine Rose Sale', date:'Saturday, Jan. 29'},
	{url:'jsa.jpg', title:'JSA Bubble Pi Brioche Sale', date:'Thursday, Feb. 3'},
	{url:'kesem.jpg', title:'Camp Kesem Info Session', date:'Tuesday, Feb. 16'},
	{url:'korea.jpg', title:'Korean New Year: FREE DDOK GUK EVENT', date:'Thursday, Feb. 3'},
	{url:'lg.jpg', title:'Lunar Gala: Melange', date:'Saturday, Feb. 5'},
	{url:'onib.jpg', title:'One Night in Beijing Performance Auditions', date:'Wednesday, Feb. 9'},
	{url:'romance.jpg', title:'Romance Kits: Valentine\'s Day Sale', date:'Monday, Feb. 14'},
	{url:'rose.jpg', title:'Chocolate Rose Grams', date:'Monday, Feb. 14'},
	{url:'sc2.jpg', title:'Conaboy VS Sit $200 SC2 Showmatch', date:'Thursday, Feb. 3'},
	{url:'superbowl.jpg', title:'AB Special Events: Superbowl Screening', date:'Sunday, Feb. 6'},
	{url:'titus.jpg', title:'Titus Adronicus with Passengers', date:'Sunday, Feb. 13'},
	{url:'polo.jpg', title:'Women\'s Water Polo Bake Sale', date:'Monday, Feb. 28'},
	{url:'famine.jpg', title:'CMU 30 Hour Famine', date:'Friday, Feb. 25'},
	{url:'engie.jpg', title:'Mr. Engineer 2011', date:'Friday, Feb. 25'},
	{url:'battle.jpg', title:'BATTLEZONE 4 Breakdance Battles @ CMU', date:'Saturday, Feb. 26'},
	{url:'playoffs.jpg', title:'Playoffs', date:'Friday, Feb. 25'},
	{url:'apple.jpg', title: 'Magical, Revolutionary, Unbelievably Priced Pt. 2', date:'Wednesday, Mar. 2'}
	];

$.shuffle(possibleEvents); // More randomness
/*
for(i=1; i<=numEvents; i++) {
	var category = Math.ceil(Math.random()*10); // Pick category between one and three

	if(i%(Math.ceil(Math.random()*numEvents)) == 0) { $.shuffle(possibleEvents) } // Shuffle randomly.

	var eventData = possibleEvents[i%possibleEvents.length];
	var eventBox = $("<div />", { id: "event-" + i, "class": "box col" + category});
	var b = $("<img />", { src: "img/events/" + eventData.url, alt: eventData.title});
	var c = $("<h3 />", { text: eventData.title });
	var d = $("<p />", { text: eventData.date });

	eventBox.append(b, c, d);

	var eventDesc = $("<div />", {id: "event-" + i + "-desc", "class": "reveal-modal event-desc"});
	var e = $("<h4 />", { text: eventData.title});
	eventDesc.append(e);

	for(var j = 0; j<category+3; j++) {
		eventDesc.append($('<p>This is an event description.  Useful information goes here!</p>'));
	}*/
/*
	//a.appendTo('#events');
	$('#events').append(eventBox, eventDesc);
}*/

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
	});
});