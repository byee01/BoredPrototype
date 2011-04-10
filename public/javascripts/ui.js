$(function() {
	
	/* CLEARS SEARCH ON CLICK */
	$('#topSearch').focus(function(e) {
		this.value = '';
	});
	
	/* SEARCH FUNCTIONALITY */
	$('#topSearch').keyup(function(e) {
		$.ajax({
			type: "GET",
			url: "/events/search.json",
			dataType: 'json',
			data: "search=gg",
			success: function(data){console.log("Success!"); console.log(data); },
			error: function(data){alert('json failed'); console.log(data.responseText);}
		});
	});
	
	/* CHANGES ACTIVE STATE */
	$('.nav a').click(function(e) {
		$('.select').removeClass('select');
		console.log('herro world');
		$(this).parent('li').addClass('select');
	});
	
	/* CLEARS ALL TEXT FIELDS IN "ADD NEW EVENT" AS CLICKED */
	$('#create_event input[type="text"]').focus(function(e) {
		this.value = '';
	});
	
	/* CHANGES POSTER AS STUFF IS TYPED */
	$('#e-make-title').keyup(function(e){
		var text = $(this).val();
		$('#m-flyer-overlay').html('<h2>' + text + '</h2>');
	});
	
});