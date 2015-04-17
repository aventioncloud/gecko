//Our JS

//Sliding from one slide to another

jQuery(document).ready(function ($) {


    //initialise Stellar.js
    $(window).stellar();

    //Cache some variables
    var links = $('.navigation').find('li');
    slide = $('.slide');
    button = $('.button');
	buttongotop = $('.button-go-top');
    mywindow = $(window);
    htmlbody = $('html,body');


    //Setup waypoints plugin
    slide.waypoint(function (event, direction) {

        //cache the variable of the data-slide attribute associated with each slide
        dataslide = $(this).attr('data-slide');

        //If the user scrolls up change the navigation link that has the same data-slide attribute as the slide to active and 
        //remove the active class from the previous navigation link 
        if (direction === 'down') {
            $('.navigation li[data-slide="' + dataslide + '"]').addClass('active').prev().removeClass('active');
        }
        // else If the user scrolls down change the navigation link that has the same data-slide attribute as the slide to active and 
        //remove the active class from the next navigation link 
        else {
            $('.navigation li[data-slide="' + dataslide + '"]').addClass('active').next().removeClass('active');
        }

    });

    //waypoints doesnt detect the first slide when user scrolls back up to the top so we add this little bit of code, that removes the class 
    //from navigation link slide 2 and adds it to navigation link slide 1. 
    mywindow.scroll(function () {
        if (mywindow.scrollTop() == 0) {
            $('.navigation li[data-slide="1"]').addClass('active');
            $('.navigation li[data-slide="2"]').removeClass('active');
        }
    });

    //Create a function that will be passed a slide number and then will scroll to that slide using jquerys animate. The Jquery
    //easing plugin is also used, so we passed in the easing method of 'easeInOutQuint' which is available throught the plugin.
    function goToByScroll(dataslide) {
        htmlbody.animate({
            scrollTop: $('.slide[data-slide="' + dataslide + '"]').offset().top
        }, 2000, 'easeInOutQuint');
    }



    //When the user clicks on the navigation links, get the data-slide attribute value of the link and pass that variable to the goToByScroll function
    links.click(function (e) {
        e.preventDefault();
        dataslide = $(this).attr('data-slide');
        goToByScroll(dataslide);
    });

    //When the user clicks on the button, get the get the data-slide attribute value of the button and pass that variable to the goToByScroll function
    button.click(function (e) {
        e.preventDefault();
        dataslide = $(this).attr('data-slide');
        goToByScroll(dataslide);

    });
	    buttongotop.click(function (e) {
        e.preventDefault();
        dataslide = $(this).attr('data-slide');
        goToByScroll(dataslide);

    });


});




//Animation

		$(function(){
		$('.vehicles2')
		.animate({
			backgroundPosition: '10000px 0px'
		}, 240000, 'linear');
			
		$('.vehicles1').animate({
			backgroundPosition:'-8000px 0px'
		}, 140000, 'linear');	
			
			
});

//Countdown

		$(function () {
		var austDay = new Date();
		austDay = new Date(austDay.getFullYear() + 1, 12 - 1, 31);
		$('#defaultCountdown').countdown({until: austDay});
		$('#year').text(austDay.getFullYear());
});

//Subscribe Form

$(function() {

  if($('#subscribe-form').length && jQuery()) {
  
    $('form#subscribe-form').submit(function() {

      $('form#subscribe-form .error').remove();
        var hasError = false;

        $('.required').each(function() {
          if(jQuery.trim($(this).val()) === '') {
            var labelText = $(this).prev('label').text();
            $(this).parent().append('<div class="error">Please enter your Email'+labelText+'</div>');
            $(this).addClass('inputError');
            hasError = true;
          } else if($(this).hasClass('mail')) {
            var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
            if(!emailReg.test(jQuery.trim($(this).val()))) {
            var labelText = $(this).prev('label').text();
            $(this).parent().append('<div class="error">Please enter a valid email address'+labelText+'</div>');
            $(this).addClass('inputError');
            hasError = true;
            }
          }
        });

        if(!hasError) {
          $('form#subscribe-form input.submit').fadeOut('normal', function() {
            $(this).parent().append('');
          });
          var formInput = $(this).serialize();
          $.post($(this).attr('action'),formInput, function(data){
            $('form#subscribe-form').slideUp("fast", function() {
              $(this).before('<div class="error">Obrigado pelo cadastro!</div>');
			  location.href="http://www.gogopark.com.br/sucesso.html"
            });
			 location.href="http://www.gogopark.com.br/sucesso.html"
          });
        }

        return false;
    });
  }
});


//Quotes Rotator
			$( function() {
				/*
				- how to call the plugin:
				$( selector ).cbpQTRotator( [options] );
				- options:
				{
					// default transition speed (ms)
					speed : 700,
					// default transition easing
					easing : 'ease',
					// rotator interval (ms)
					interval : 8000
				}
				- destroy:
				$( selector ).cbpQTRotator( 'destroy' );
				*/

				$( '#cbp-qtrotator' ).cbpQTRotator();

			} );

//Google Map

$(document).ready(function() {


$("#collapseOne").on('shown.bs.collapse', function(e)
    {
		lastCenter=map.getCenter();
        google.maps.event.trigger(map, 'resize');
		 map.setCenter(lastCenter);

    });

var map;
var newyork = new google.maps.LatLng(40.717306, -73.996536);
 
var MY_MAPTYPE_ID = 'mystyle';
 
var stylez =  [{"featureType":"water","elementType":"geometry","stylers":[{"color":"#569391"}]},{"featureType":"landscape","elementType":"geometry","stylers":[{"color":"#ebd3b8"}]},{"featureType":"road","elementType":"geometry","stylers":[{"color":"#d7b289"}]},{"featureType":"poi","elementType":"geometry","stylers":[{"color":"#ecceac"}]},{"featureType":"transit","elementType":"geometry","stylers":[{"color":"#ecceac"}]},{"elementType":"labels.text.stroke","stylers":[{"visibility":"on"},{"color":"#c09362"},{"weight":4}]},{"elementType":"labels.text.fill","stylers":[{"color":"#ffffff"}]},{"featureType":"administrative","elementType":"geometry","stylers":[{"weight":0.6},{"color":"#1a3541"}]},{"elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#e5c7a5"}]}]
 
  var mapOptions = {
    zoom: 12,
    center: newyork,
	disableDefaultUI: true,
    mapTypeControlOptions: {
       mapTypeIds: [google.maps.MapTypeId.ROADMAP, MY_MAPTYPE_ID]
    },
    mapTypeId: MY_MAPTYPE_ID
  };
 
  map = new google.maps.Map(document.getElementById("map_canvas"),
      mapOptions);
 
  var styledMapOptions = {
    name: "We are here"
  };
 
  var jayzMapType = new google.maps.StyledMapType(stylez, styledMapOptions);
 
  map.mapTypes.set(MY_MAPTYPE_ID, jayzMapType);
});
