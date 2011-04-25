/*
 * jQuery Reveal Plugin 1.0
 * www.ZURB.com
 * Copyright 2010, ZURB
 * Free to use under the MIT license.
 * http://www.opensource.org/licenses/mit-license.php
*/


(function($) {

/*---------------------------
 Defaults for Reveal
----------------------------*/
	 
/*---------------------------
 Listener for data-reveal-id attributes
----------------------------*/

	$('div.box').live('click', function(e) {
		e.preventDefault();
		var modalLocation = $(this).attr('id');
		$('#'+modalLocation+"-desc").reveal($(this));

		var gaLink = "user-click/event-" + modalLocation;
		 _gaq.push(['_trackPageview', gaLink]);
		$('.editable_fields').hide();
		$('.presentable_fields').show();
		$('.ajax_errors').hide();
	});

/*---------------------------
 Extend and Execute
----------------------------*/

    $.fn.reveal = function(options) {
        
        
        var defaults = {  
		    animationspeed: 300, //how fast animtions are
		    dismissmodalclass: 'close-reveal-modal' //the class of a button or element that will close an open modal
    	}; 
    	
        //Extend dem' options
        var options = $.extend({}, defaults, options); 
	
        return this.each(function() {
        
/*---------------------------
 Global Variables
----------------------------*/
        	var modal = $(this),
        		topMeasure  = parseInt(modal.css('top')),
				topOffset = modal.height() + topMeasure,
          		locked = false,
				modalBG = $('.reveal-modal-bg');

/*---------------------------
 Create Modal BG
----------------------------*/
			if(modalBG.length == 0) {
				modalBG = $('<div class="reveal-modal-bg" />');
				modalBG.appendTo('body');
			}		    
        	
/*---------------------------
 Open and add Closing Listeners
----------------------------*/
        	//Open Modal Immediately
    		openModal();
			
			//Close Modal Listeners
			modalBG.css({"cursor":"pointer"});
			modalBG.bind('click.modalEvent',closeModal);
			$('body').keyup(function(e) {
        		if(e.which===27){ closeModal(); } // 27 is the keycode for the Escape key
			});
			
    		
/*---------------------------
 Open & Close Animations
----------------------------*/
			//Entrance Animations
			function openModal() {
				modalBG.unbind('click.modalEvent');
				$('.' + options.dismissmodalclass).unbind('click.modalEvent');
				if(!locked) {
					lockModal();
					//modal.css({'top': $(document).scrollTop()-topOffset, 'opacity' : 0, 'visibility' : 'visible'});
					modal.css({'top': 0, 'opacity' : 0, 'visibility' : 'visible'});
					modalBG.fadeIn(options.animationspeed/2);
					modal.delay(options.animationspeed/2).animate({
						"top": $(document).scrollTop()+topMeasure,
						"opacity" : 1
					}, options.animationspeed,unlockModal());
				}
			}    	
			
			//Closing Animation
			function closeModal() {
				if(!locked) {
					lockModal();
					modalBG.delay(options.animationspeed).fadeOut(options.animationspeed);
					modal.animate({
						"top":  $(document).scrollTop()-topOffset,
						"opacity" : 0
					}, options.animationspeed/2, function() {
						modal.css({'top':topMeasure, 'opacity' : 1, 'visibility' : 'hidden'});
						unlockModal();
					});	
				}
			}
			
/*---------------------------
 Animations Locks
----------------------------*/
			function unlockModal() { 
				locked = false;
			}
			function lockModal() {
				locked = true;
			}	
			
        });//each call
    }//orbit plugin call
})(jQuery);
        
