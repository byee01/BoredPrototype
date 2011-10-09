// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs

// Load order:
// 1. jquery/underscore
// 2. backbone
// 3. Events to set up and initialize app
// 4. Rest of tree (backbone model, view, controller)
// 5. Initialize app

//  Underscore is a dependency for backbone.js
//= require underscore-min
//= require backbone

//= require events

//= require_tree .

$(function() {
  App.init();
});
