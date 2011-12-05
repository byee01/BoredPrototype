// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

/* TEMPORARILY REMOVE ISOTOPE
var $container = $('#events');

// Set up isotope on .event
$container.isotope({
  itemSelector: '.event'
});

// Expand event when clicked
$container.delegate('.event', 'click', function() {

  $(this).toggleClass('expanded');
  
  // This causes severe performance issues.
  $container.isotope('reLayout');
});
*/
/*

var App = {
  Views: {},
  Routers: {},
  init: function() {
    new App.Routers.Events();
    Backbone.history.start();
  }
};
*/

function updateInfo(node) {
  var infoBar = $('.info-main');
  $('#info-title', infoBar).html($('.event-title', node).html());
  $('#info-desc', infoBar).html($('.event-desc', node).html());
  $('#info-location', infoBar).html($('.event-location', node).html());
  $('#info-date', infoBar).html($('.event-date', node).html());
}


$(function() {
  $('.datepicker').datepicker();
  $('.event').click(function(){
    updateInfo(this);
  });

	/* HAROLD'S CODE DO NOT INSULT */
	$('ul.category-list').click(function(e){
		$('li', this).css('top', 0);
		console.log(e.target);
		$(this).toggleClass('expanded');
		$('.events-col-info').toggle();
	});
});

$('.field input').focus(function(){
  $(this).parent().addClass('form-focus');
});
$('.field input').blur(function(){
  $(this).parent().removeClass('form-focus');
});