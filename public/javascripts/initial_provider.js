$(document).ready(function(){
var init;
if (Modernizr.localstorage) {
  if($.cookie('login_provider')){
		if($.cookie('login_provider').indexOf('+') != -1){
			init = $.cookie('login_provider').split('+')[0];
		} else {
			init = $.cookie('login_provider');
		}
		localStorage.setItem('init', init);
	}
	if(localStorage.getItem('init')){
		var initial_provider = localStorage.getItem('init');
	
		if(initial_provider == 'google'){$('.google a').css('background', 'url(/images/login_icons.png) 0 0 no-repeat');}
		if(initial_provider == 'yahoo'){$('.yahoo a').css('background', 'url(/images/login_icons.png) -34px 0 no-repeat');}
		if(initial_provider == 'twitter'){$('.twitter a').css('background', 'url(/images/login_icons.png) -68px 0 no-repeat');}
		if(initial_provider == 'facebook'){$('.facebook a').css('background', 'url(/images/login_icons.png) -102px 0 no-repeat');}
   
	}
	
} else {
	if($.cookie('login_provider')){
		if($.cookie('login_provider').indexOf('+') != -1){
			init = $.cookie('login_provider').split('+')[0];
		} else {
			init = $.cookie('login_provider');
		}
		var initial_provider = init;
				if(initial_provider == 'google'){$('.google a').css('background', 'url(/images/login_icons.png) 0 0 no-repeat');}
		if(initial_provider == 'yahoo'){$('.yahoo a').css('background', 'url(/images/login_icons.png) -34px 0 no-repeat');}
		if(initial_provider == 'twitter'){$('.twitter a').css('background', 'url(/images/login_icons.png) -68px 0 no-repeat');}
		if(initial_provider == 'facebook'){$('.facebook a').css('background', 'url(/images/login_icons.png) -102px 0 no-repeat');}
	}
}


});