//post image to facebook
function share_image_fb(){
		$.post('/account/upload/fb', { input: 'image', fb_share_text: $('#share_text').val(), fb_url: $('#share_url').val() }, function(){
		$('#share_text').val('');
		$('.share_box').slideUp(200);
		
		});
	}
//post image to twitter
function share_image_tw(){
		$.post('/account/upload/tw', { input: 'image', tw_share_text: $('#share_text').val(), tw_url: $('#share_url').val() }, function(){
		$('#share_text').val('');
		$('.share_box').slideUp(200);
		
		});
	}
//post audio to facebook
function share_audio_fb(){
		$.post('/account/upload/fb', { input: 'audio', fb_share_text: $('#share_text_audio').val(), fb_url: $('#share_url_audio').val() }, function(){
		$('#share_text_audio').val('');
		$('.share_box').slideUp(200);
		
		});
	}
//post audio to twitter
function share_audio_tw(){
		$.post('/account/upload/tw', { input: 'audio', tw_share_text: $('#share_text_audio').val(), tw_url: $('#share_url_audio').val() }, function(){
		$('#share_text_audio').val('');
		$('.share_box').slideUp(200);
		
		});
	}
//post video to facebook
function share_video_fb(){
		$.post('/account/upload/fb', { input: 'video', fb_share_text: $('#share_text_video').val(), fb_url: $('#share_url_video').val() }, function(){
		$('#share_text_video').val('');
		$('.share_box').slideUp(200);
		
		});
	}
//post video to twitter
function share_video_tw(){
		$.post('/account/upload/tw', { input: 'video', tw_share_text: $('#share_text_video').val(), tw_url: $('#share_url_video').val() }, function(){
		$('#share_text_video').val('');
		$('.share_box').slideUp(200);
		$('.share_box').slideUp(200);
		
		});
	}
	
// adjust browser detection
var userAgent = navigator.userAgent.toLowerCase(); 
$.browser.chrome = /chrome/.test(navigator.userAgent.toLowerCase()); 

// Is this a version of Chrome?
if($.browser.chrome){
  userAgent = userAgent.substring(userAgent.indexOf('chrome/') +7);
  userAgent = userAgent.substring(0,userAgent.indexOf('.'));
  $.browser.version = userAgent;
  // If it is chrome then jQuery thinks it's safari so we have to tell it it isn't
  $.browser.safari = false;
}

// Is this a version of Safari?
if($.browser.safari){
  userAgent = userAgent.substring(userAgent.indexOf('safari/') +7);
  userAgent = userAgent.substring(0,userAgent.indexOf('.'));
  $.browser.version = userAgent;
}

// login popup
var newwindow;
function login(provider_url, width, height) {
  var screenX     = typeof window.screenX != 'undefined' ? window.screenX : window.screenLeft,
      screenY     = typeof window.screenY != 'undefined' ? window.screenY : window.screenTop,
      outerWidth  = typeof window.outerWidth != 'undefined' ? window.outerWidth : document.body.clientWidth,
      outerHeight = typeof window.outerHeight != 'undefined' ? window.outerHeight : (document.body.clientHeight - 22),
      left        = parseInt(screenX + ((outerWidth - width) / 2), 10),
      top         = parseInt(screenY + ((outerHeight - height) / 2.5), 10),
      features    = ('width=' + width + ',height=' + height + ',left=' + left + ',top=' + top);

      newwindow = window.open(provider_url, 'Login', features);

  if (window.focus)
    newwindow.focus();

  return false;
}


// drop upload

	(function( $ ){
		
		var methods = {
			init: function(options){
				return this.each(function(){
					var $this = $(this);
					
					$.each(options, function( label, setting ) {
						$this.data(label, setting);
					});
					
					$this.bind('dragenter.upload', methods.dragEnter);
					$this.bind('dragover.upload', methods.dragOver);
					$this.bind('dragleave.upload', methods.dragLeave);
					$this.bind('drop.upload', methods.drop);
				});
			},
			
			dragEnter : function(event){
				event.stopPropagation();
				event.preventDefault();
				var $this = $(this);
				$this.html('!');
				$this.animate({
					width: '250px',
					height: '250px'
					}, 200, function(){
						$this.css({'border':'3px solid #000','font-size':'32px','text-align':'center'})
				});
				
				return false;
			},
			
			dragOver : function(event){
				event.stopPropagation();
				event.preventDefault();
				return false;
			},
			
			dragLeave : function(event){
				event.stopPropagation();
				event.preventDefault();
				var $this = $(this);
				$this.html('Drop Image Here');
				$this.animate({
					width: '65px',
					height: '65px'
					}, 200, function(){
						$this.css({'border':'1px dotted #444','font-size':'13px','text-align':'left'})
				});
				return false;
			},
			
			drop : function(event){
				event.stopPropagation();
				event.preventDefault();
				
				var $this = $(this);
				$this.animate({
					width: '65px',
					height: '65px'
					}, 200, function(){
						$this.css({'border':'1px dotted #444','font-size':'13px','text-align':'left'})
				});
				var dataTransfer = event.originalEvent.dataTransfer;
				if(dataTransfer.files.length > 0){
					$.each(dataTransfer.files, function(i, file){
						var xhr = new XMLHttpRequest();
						var upload = xhr.upload;
						xhr.open($this.data('method') || 'POST', $this.data('url'), true);
						xhr.setRequestHeader('X-Filename', file.fileName);
						$this.css({'border':'none','font-size':'10px','text-align':'left'})
						$this.html('<em>uploading...</em>');
						
						xhr.send(file);
						xhr.onreadystatechange = uploaded;
					});
				};
				
				return false;
			}
		
		};
		
		$.fn.upload = function(method){
			if(methods[method]){
				return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
			}
			else if(typeof method === 'object' || ! method){
				return methods.init.apply(this, arguments);
			}
			else{
				$.error('Method ' + method +' does not exist' );
			}
		};
		
		function uploaded(){
			$('.av-upload').html('Success!');
			update_shit();
			if(window.location.href.indexOf('settings') == -1){
				$('.av-upload').hide()
			}
		}
	})(jQuery);

//text count
(function(jQuery) {
	jQuery.fn.textlimit=function(counter_el, thelimit, speed) {
		var charDelSpeed = speed || 15;
		var toggleCharDel = speed != -1;
		var toggleTrim = true;
		var that = this[0];
		var isCtrl = false; 
		updateCounter();
		
		function updateCounter(){
			if(typeof that == "object")
				jQuery(counter_el).text(thelimit - that.value.length+" ");
		};
		
		this.keydown (function(e){ 
			if(e.which == 17) isCtrl = true;
			var ctrl_a = (e.which == 65 && isCtrl == true) ? true : false; // detect and allow CTRL + A selects all.
			var ctrl_v = (e.which == 86 && isCtrl == true) ? true : false; // detect and allow CTRL + V paste.
			// 8 is 'backspace' and 46 is 'delete'
			if( this.value.length >= thelimit && e.which != '8' && e.which != '46' && ctrl_a == false && ctrl_v == false)
				e.preventDefault();
		})
		.keyup (function(e){
			updateCounter();
			if(e.which == 17)
				isCtrl=false;

			if( this.value.length >= thelimit && toggleTrim ){
				if(toggleCharDel){
					// first, trim the text a bit so the char trimming won't take forever
					// Also check if there are more than 10 extra chars, then trim. just in case.
					if ( (this.value.length - thelimit) > 10 )
						that.value = that.value.substr(0,thelimit+100);
					var init = setInterval
						( 
							function(){ 
								if( that.value.length <= thelimit ){
									init = clearInterval(init); updateCounter() 
								}
								else{
									// deleting extra chars (one by one)
									that.value = that.value.substring(0,that.value.length-1); jQuery(counter_el).text('Trimming... '+(thelimit - that.value.length));
								}
							} ,charDelSpeed 
						);
				}
				else this.value = that.value.substr(0,thelimit);
			}
		});
		
	};
})(jQuery);	
	

// pm note

function pm_note(){

var unread = parseInt($('.inboxNotification').html());
if(unread > 0){
	$('.inboxNotification').html('<a href="/account/inbox" title="Go to your inbox"><img src="/images/pmnote-16.png" alt="new message(s)" /></a>');
} else {
	$('.inboxNotification').html('');
}

}
	
//update shit

function update_shit(){
	$.post("/account/update");	
}	



//checkbox uploads
function attachment_audio_checkbox(){
	$('.form_video').hide();
	$('.form_image').hide();
	$('.form_archive').hide();
	$('.form_audio').show();
	$('.allowedfiles').html('Allowed file types: .wav, .mp3, .ogg');
}

function attachment_video_checkbox(){
	$('.form_audio').hide();
	$('.form_image').hide();
	$('.form_archive').hide();
	$('.form_video').show();
	$('.allowedfiles').html('Allowed file types: .mkv, .ogg, .flv, .avi, .mpg, .mp4');
}

function attachment_image_checkbox(){
	$('.form_video').hide();
	$('.form_audio').hide();
	$('.form_archive').hide();
	$('.form_image').show();
	$('.allowedfiles').html('Allowed file types: .png, .jpg, .gif');
}

function attachment_archive_checkbox(){
	$('.form_video').hide();
	$('.form_audio').hide();
	$('.form_image').hide();
	$('.form_archive').show();
	$('.allowedfiles').html('Allowed file types: .7z, .rar, .tar.gz, .zip');
}					
	
$(document).ready(function(){

	$.preloadCssImages();

// initial login	
	
	$('li.google').click(function(){
		window.location.href = 'auth/google';
	});
	
	$('li.yahoo').click(function(){
		window.location.href = 'auth/yahoo';
	});
	
	$('li.twitter').click(function(){
		window.location.href = 'auth/twitter';
	});
	
	$('li.facebook').click(function(){
		window.location.href = 'auth/facebook';
	});

// associate additional login methods	
	
	$('li.google2').click(function(){
		login('/auth/google', 600, 400);
	});
	
	$('li.yahoo2').click(function(){
		login('/auth/yahoo', 600, 400);
	});
	
	$('li.twitter2').click(function(){
		login('/auth/twitter', 600, 400);
	});
	
	$('li.facebook2').click(function(){
		login('/auth/facebook', 600, 400);
	});
	
// avatar
	
	if ($.browser.chrome) {
    $('.av-upload').upload({url : '/account/upload'});
		//$('.avatar_form').css('display', 'none');
	} else if ($.browser.safari) {
			$("html").addClass('fuckingSafari');
	} else if (!($.browser.opera)) {
		if (Modernizr.draganddrop) {
			if ("files" in DataTransfer.prototype){
				$('.av-upload').upload({url : '/account/upload'});
				//$('.avatar_form').css('display', 'none');
			} else {
			$('.av-upload').css('display', 'none');
			$('p.avselect').css('display', 'none');
			}
		} else {
			$('.av-upload').css('display', 'none');
			$('p.avselect').css('display', 'none');
		}
	}

	
// site message hide on click

$(document).click(function(){
	$('.site_messages').fadeOut(300);
});
	

// text area character count
$('textarea#post_content').textlimit('span.counter', 150);
$('textarea#twitter_post').textlimit('span.twittercount', 140);


// default twitter avatar fix
if($('.twitterTitle').length > 0){
	if($('.twitterTitle img').attr('src').indexOf('default') != -1){
		$('.twitterTitle img').hide();
	}
}

//IE userlist fix
if ($.browser.msie) {
	$('li.userlist:nth-child(odd)').css({'background':'url(/images/0-40.png)','color':'#0a0a0a', 'margin':'10px 0'});
	$('li.userlist:nth-child(odd) a').css('color', '#0a0a0a !important;');
	$('li.userlist:nth-child(even)').css({'background':'url(/images/0-60.png)','color':'#d7d7d7', 'margin':'10px 0'});
	$('li.userlist:nth-child(even) a').css('color', '#d7d7d7 !important;');
}

//pm system
if ($.browser.msie) {
	$('li.messagerow:nth-child(odd)').css({'background':'url(/images/f-60.png)','color':'#0a0a0a'});
	$('li.messagerow:nth-child(odd) a').css('color', '#0a0a0a');
	$('li.messagerow:nth-child(even)').css({'background':'url(/images/0-60.png)','color':'#d7d7d7'});
	$('li.messagerow:nth-child(even) a').css('color', '#d7d7d7');
}
$('.subject>span').toggle(function(){
	$(this).siblings('.body').slideDown(200);
	}, function(){
	$(this).siblings('.body').slideUp(200);
});

$('.pmReply').click(function(){
	var replyText = $(this).html();
	$(this).html('loading');
	href = $(this).parents('.subject').siblings('.from').find('a').attr('href');
	$(this).parent().siblings('.reply').load('http://q.metatroid.com'+href+'  .pmForm', function(){
		$('.pmReply').html(replyText);
		$(this).parent().siblings('.reply').show();
		$(this).parent().find('input#message_subject').val("RE: "+$(this).parents('.subject').find('span').html());
		$(this).parent().attr('class', 'open');
		
			var form = $(this).parent().find('form#new_message');
			form.find('input#message_submit').bind('click', function(){
				var data = form.serializeArray();
				$(this).parents('.open').attr('class', 'body');
				$.ajax({url: '/messages', type: 'POST', data: data});
				return false
			});
		
	});
});

// ajax fixes for IE

if ($.browser.msie) {
	var form = $('form#new_post');
	form.find('input#post_submit').bind('click', function(){
		var data = form.serializeArray();
		$.ajax({url: '/posts', type: 'POST', data: data});
		return false
	});
	
	var form2 = $('form#new_message');
	form2.find('input#message_submit').bind('click', function(){
		var data = form2.serializeArray();
		$.ajax({url: '/messages', type: 'POST', data: data});
		return false
	});

	var form3 = $('form#new_question');
	form3.find('input#question_submit').bind('click', function(){
		var data = form3.serializeArray();
		$.ajax({url: '/questions', type: 'POST', data: data});
		return false
	});
		
	$('.fbutton input').click(function(event){ 
		event.preventDefault();
	});
			
	var form4 = $('form#new_relationship');
	form4.find('input#relationship_submit').bind('click', function(){
		var data = form4.serializeArray();
		$.ajax({url: '/relationships', type: 'POST', data: data});
		return false
	});
	
	var form5 = $('form.edit_relationship');
	form5.find('input#relationship_submit').bind('click', function(){
		var destalk_action = $('form.edit_relationship').attr('action');
		var data = form5.serializeArray();
		$.ajax({url: destalk_action, type: 'POST', data: data});
		return false
	});
}

//run update script every 2.5 minutes
setInterval("update_shit()", 150000);

//facebook PM display
$('.fbcommentsLink').toggle(function(){
	$(this).siblings('.fbcomments').show();
	}, function(){
		$(this).siblings('.fbcomments').hide();
});

//initiate and set attachment checkboxes to default
$('.initiate_attach').toggle(function(){
	$('.post_attachment').slideDown(200);
	$('input#is_audio').attr('checked', false);
	$('input#is_video').attr('checked', false);
	$('input#is_archive').attr('checked', false);
	$('input#is_image').attr('checked', true);
	$('input#is_image').click(function(){$(this).siblings('input:checkbox').attr('checked', false); $(this).attr('checked', true)});
	$('input#is_audio').click(function(){$(this).siblings('input:checkbox').attr('checked', false); $(this).attr('checked', true)});
	$('input#is_video').click(function(){$(this).siblings('input:checkbox').attr('checked', false); $(this).attr('checked', true)});
	$('input#is_archive').click(function(){$(this).siblings('input:checkbox').attr('checked', false); $(this).attr('checked', true)});
	$('.initiate_attach').html('Cancel Upload');
	}, function(){
		$('.post_attachment').slideUp(200);
		$('.initiate_attach').html('Attach');
});

//audio embed
if (Modernizr.audio) {
	$('span.listen').toggle(function(){
		$(this).parent().siblings('.audio_embed-html5').slideDown(200);
		return false
	}, function(){
		$(this).parent().siblings('.audio_embed-html5').slideUp(200);
		return false
	});
} else {
	$('span.listen').toggle(function(){
		$(this).parent().siblings('.audio_embed-flash').slideDown(200);
		return false
	}, function(){
		$(this).parent().siblings('.audio_embed-flash').slideUp(200);
		return false
	});
}

//video embed
$('span.watch').toggle(function(){
		$(this).parent().siblings('.video_embed').slideDown(200);
		return false
	}, function(){
		$(this).parent().siblings('.video_embed').slideUp(200);
		return false
});

//open files for backgrounds
if($.browser.msie){var you="fucking retarded";
} else {
$('.open_files').click(function(){
	var offset = $('.settings').offset();
	var css = "position:fixed; "
        + "z-index:9999; "
        + "display: none;"
        + "color: #444;"
        + "font-size: 11px;"
        + "font-family: Arial, sans-serif;"
        + "background:#e7e7e7; "
        + "left: " + offset.left + "px;" 
        + "top: " + (window.innerHeight/4) + "px;"
        + "max-width: " + (window.innerWidth/2) + "px;"
        + "min-width: 100px;"
        + "min-height: 100px;"
        + "max-height: " + (window.innerHeight-window.innerHeight/4-50) + "px;"
        + "border: 4px #000 solid; "
        + "margin: 0; "
        + "padding: 5px; "
        + "overflow: auto;";

	var file_window = document.createElement('div');
	file_window.setAttribute('style', css);
	file_window.setAttribute('class', 'file_window');
	document.body.appendChild(file_window);
	$(file_window).html('<div class="file_close"></div><div class="file_contents">loading...</div><div class="file_confirm"></div>');
	$('.file_contents').load('/account/uploads .uploaded_images', function(){
		$('.delete_image').hide();
		$('.share_image').hide();
		$('.file_confirm').show();
		$('.uploaded_images').find('a').each(function(){
			$(this).click(function(){
				$(this).parent().addClass('selected_image');
				$(this).parent().siblings().removeClass('selected_image');
				return false;
			});
		});
	});
	$('.file_close').html('<a style="color: black;font-weight:bold;float:right" href="#" onclick="$(\'.file_window\').hide()"> X </a>');
	
	$('.file_confirm').html('<a style="color:black;font-weight:bold;float:right" href="#" onclick="$(\'input#background\').val($(\'.selected_image\').find(\'a\').attr(\'href\'));$(\'.file_window\').hide()">Confirm</a>');
	
	$(file_window).slideDown(200);
});
}
//fuck IE, that shit is not fucking working but works everywhere else, so if you use IE, fuck you, deal with it
if($.browser.msie){
	$('.background_desc').html('Upload a different background image');
}


//upload sharing
$('.share_image').click(function(){
	var url = $(this).parent().find('.uploaded_item').attr('href');
	$(this).parents('.upload_container').find('input').val("http://q.metatroid.com"+url);
	$(this).parents('.upload_container').find('.share_box').slideDown(200);
	$(this).parents('li').siblings().css({'border':'none','padding':'0'});
	$(this).parents('li').css({'border':'2px solid #a00','padding':'10px'});
});
$('.share_audio').click(function(){
	var url = $(this).parent().find('.listen_full a').attr('href');
	$(this).parents('.upload_container').find('input').val(url);
	$(this).parents('.upload_container').find('.share_box').slideDown(200);
	$(this).parents('li').siblings().css({'border':'none','padding':'0'});
	$(this).parents('li').css({'border':'2px solid #a00','padding':'10px'});
	$(this).parents('li').siblings().find('.dl_links').hide();
	$(this).parents('li').find('.dl_links').show();
});
$('.share_video').click(function(){
	var url = $(this).parent().find('.watch_full a').attr('href');
	$(this).parents('.upload_container').find('input').val(url);
	$(this).parents('.upload_container').find('.share_box').slideDown(200);
	$(this).parents('li').siblings().css({'border':'none','padding':'0'});
	$(this).parents('li').css({'border':'2px solid #a00','padding':'10px'});
	$(this).parents('li').siblings().find('.dl_links').hide();
	$(this).parents('li').find('.dl_links').show();
});
//set checkboxes
$('input#is_audio').attr('checked', false);
	$('input#is_video').attr('checked', false);
	$('input#is_archive').attr('checked', false);
	$('input#is_image').attr('checked', true);
	$('input#is_image').click(function(){$(this).siblings('input:checkbox').attr('checked', false); $(this).attr('checked', true)});
	$('input#is_audio').click(function(){$(this).siblings('input:checkbox').attr('checked', false); $(this).attr('checked', true)});
	$('input#is_video').click(function(){$(this).siblings('input:checkbox').attr('checked', false); $(this).attr('checked', true)});
	$('input#is_archive').click(function(){$(this).siblings('input:checkbox').attr('checked', false); $(this).attr('checked', true)});
	
//link hover
$('input.directLink').hover(function(){$(this).focus();$(this).select();},function(){$(this).val($(this).val());});
$('input.displayLink').hover(function(){$(this).focus();$(this).select();},function(){$(this).val($(this).val());});


//example audio
var settings = {
            progressbarWidth: '200px',
            progressbarHeight: '5px',
            progressbarColor: '#000',
            progressbarBGColor: '#ddd',
            defaultVolume: 0.8,
            title: '01xe13.mp3'
        };
        if(Modernizr.audio){$(".player").player(settings);}

//end on ready
});

//opera is retarded
if ($.browser.opera) {
	$("html").addClass('fuckingOpera');
}	


