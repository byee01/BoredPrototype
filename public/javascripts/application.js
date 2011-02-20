$(document).ready(function(){

	$('#new_event_btn').click(function(){
		$('#new_event').fadeIn();
		clear_form_elements('#new_event form');
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