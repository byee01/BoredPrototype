// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

//= require isotope
var $container = $('#events');

// Set up isotope on .event
$container.isotope({
  itemSelector: '.event'
});

// Expand event when clicked
$container.delegate('.event', 'click', function() {
  $(this).toggleClass('expanded');
  $container.isotope('reLayout');
});
