class UsersController < ApplicationController
	require 'bitly'
	require 'RMagick'
	include Magick
	before_filter :require_user
	before_filter :admin_user, :only => :destroy
	
	def show
		@user = current_user
		unless @user.authorizations.nil?
			@authorization = @user.authorizations.all
			unless current_user.authorizations.find(:all, :conditions => { :provider => 'twitter' }).blank?
				twitter_array = current_user.authorizations.find(:all, :conditions => { :provider => 'twitter' })[0]
				@token = twitter_array['token']
				@secret = twitter_array['secret']
				@twitter_name = twitter_array['nickname']
				Twitter.configure do |config|
					config.consumer_key = 'y1ur5nbJre7OKYBj6qu39g'
					config.consumer_secret = 'erWPi7Nn8scCBs9wuHSi2eswcI7F287pVTCVQ4sr5Y'
					config.oauth_token = @token
					config.oauth_token_secret = @secret
				end
				@tweet = Twitter.home_timeline
				@twitter_image = twitter_array['image'].gsub(/_normal/, '')
				@friends = Twitter.friends.users
				@followers = Twitter.followers.users
			end
			unless current_user.authorizations.find(:all, :conditions => { :provider => 'facebook' }).blank?
				fbinfo = client.selection.me.info!
				@fbname = fbinfo.first_name << ' ' << fbinfo.last_name
				@fbposts = client.selection.me.home.info!['data']
				@fbfeed = client.selection.me.feed.info!
				@fbimage = "https://graph.facebook.com/#{fbinfo['id']}/picture?type=large"
				@fblink = client.selection.me.info!.link
				@fbinbox = client.selection.me.inbox.info!['data']
				@fbfriends = client.selection.me.friends.info!['data']
				
				#i = client.selection.me.inbox.info!['data']
				#n = i.length
				#x = n
				#q = 0
				#while q < x
				#	n += i[q].comments['data'].length
				#	q += 1
				#end
				#@fbcount = n
				
			end
			unless current_user.authorizations.find(:all, :conditions => { :provider => 'yahoo' }).blank?
				@yahoo_name = current_user.authorizations.find(:all, :conditions => { :provider => 'yahoo' })[0]['name']
			end
			unless current_user.authorizations.find(:all, :conditions => { :provider => 'google' }).blank?
				@google_name = current_user.authorizations.find(:all, :conditions => { :provider => 'google' })[0]['name']
			end
		end
		@posts = @user.posts.paginate(:page => params[:page], :per_page => 5)
		@post = current_user.posts.build(params[:post])
		@feed_items = current_user.feed.paginate(:page => params[:page], :per_page => 5)
		@status_items = current_user.status_feed.paginate(:page => params[:page], :per_page => 5)
		@messages = @user.inbox
	end
	
	def post_twitter
		Twitter.update(params[:twitter_post])
	end

	def post_facebook
		fbuser = client.selection.me.info!
		client.selection.user(fbuser[:id]).feed.publish!(:message => params[:fb_post])
	end
	def edit
		@user = current_user
		@authorization = @user.authorizations.all
		@providers = []
		@authorization.each do |a|
			@providers.push(a.provider)
		end
		respond_to do |format|
			format.html # show.html.erb
			format.xml { render :xml => @user } 
		end
	end
	def update
    @user = current_user
		@providers = []
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to :back
    else
      @title = "Edit user"
      render 'edit'
    end
  end
	
	def fail
		@title = 'auth failure'
	end

	def upload
		
		@user = current_user
		
		name = "avatar.png"
    data = request.raw_post
    
		@file_content = File.open("#{Rails.root.to_s}/tmp/#{name}", "wb") do |f| 
      f.write(data)
    end
		@file = File.new("#{Rails.root.to_s}/tmp/#{name}")
    @user.uploads.create do |p|
			p.photo = @file
		end
    File.delete("#{Rails.root.to_s}/tmp/#{name}")
    
	end
		
	def index
		@users = User.paginate(:page => params[:page], :per_page => 5)
		@user = current_user
	end
	
	def profile
		@user = User.find(params[:id])
		@posts = @user.posts.paginate(:page => params[:page], :per_page => 5)
		@message = Message.new
		@div = @user.divs
		@font = @user.fonts
		@background = @user.background
		unless @user.authorizations.nil?
			@authorization = @user.authorizations.all
			unless @user.authorizations.find(:all, :conditions => { :provider => 'twitter' }).blank?
				twitter_array = @user.authorizations.find(:all, :conditions => { :provider => 'twitter' })[0]
				@token = twitter_array['token']
				@secret = twitter_array['secret']
				@twitter_name = twitter_array['nickname']
				Twitter.configure do |config|
					config.consumer_key = 'y1ur5nbJre7OKYBj6qu39g'
					config.consumer_secret = 'erWPi7Nn8scCBs9wuHSi2eswcI7F287pVTCVQ4sr5Y'
					config.oauth_token = @token
					config.oauth_token_secret = @secret
				end
				@tweet = Twitter.user_timeline(@twitter_name).first.text
				@twitter_image = twitter_array['image'].gsub(/_normal/, '')
				@twitter_image_small = twitter_array['image']
			end
			unless @user.authorizations.find(:all, :conditions => { :provider => 'facebook' }).blank?
				fbinfo = profile_client.selection.me.info!
				@fbname = fbinfo.first_name << ' ' << fbinfo.last_name
				@fbstatus = profile_client.selection.me.feed.info!['data'][0]['message']
				@fbposts = profile_client.selection.me.home.info!['data']
				@fbfeed = profile_client.selection.me.feed.info!
				@fbimage = "https://graph.facebook.com/#{fbinfo['id']}/picture"
				@fblink = profile_client.selection.me.info!.link
				@fbinbox = profile_client.selection.me.inbox.info!['data']
				@fbfriends = profile_client.selection.me.friends.info!['data']
			end
		end
	end
	
	def destroy
		User.find(params[:id]).destroy
		flash[:notice] = "user deleted"
		redirect_to user_list_path	
	end

	def following
		@user = current_user
		@following = @user.following.paginate(:page => params[:page], :per_page => 5)
	end
	
	def followers
		@user = current_user
		@followers = @user.followers.paginate(:page => params[:page], :per_page => 5)
	end
	
	def inbox
		@user = current_user
		@messages = @user.inbox.paginate(:page => params[:page], :per_page => 25)
		
		@messages.each do |m|
			m.update_attribute(:read_state, true)
		end
	end
	
	def update_profile
		@user = current_user
		unless @user.authorizations.nil?
			@authorization = @user.authorizations.all
			unless current_user.authorizations.find(:all, :conditions => { :provider => 'twitter' }).blank?
				twitter_array = current_user.authorizations.find(:all, :conditions => { :provider => 'twitter' })[0]
				@token = twitter_array['token']
				@secret = twitter_array['secret']
				@twitter_name = twitter_array['nickname']
				Twitter.configure do |config|
					config.consumer_key = 'y1ur5nbJre7OKYBj6qu39g'
					config.consumer_secret = 'erWPi7Nn8scCBs9wuHSi2eswcI7F287pVTCVQ4sr5Y'
					config.oauth_token = @token
					config.oauth_token_secret = @secret
				end
				@tweet = Twitter.home_timeline
				@twitter_image = twitter_array['image'].gsub(/_normal/, '')
				@friends = Twitter.friends.users
				@followers = Twitter.followers.users
			end
			unless current_user.authorizations.find(:all, :conditions => { :provider => 'facebook' }).blank?
				fbinfo = client.selection.me.info!
				@fbname = fbinfo.first_name << ' ' << fbinfo.last_name
				@fbposts = client.selection.me.home.info!['data']
				fbfeed = client.selection.me.feed.info!
				@fbimage = "https://graph.facebook.com/#{fbinfo['id']}/picture?type=large"
				@fblink = client.selection.me.info!.link
			end
			unless current_user.authorizations.find(:all, :conditions => { :provider => 'yahoo' }).blank?
				@yahoo_name = current_user.authorizations.find(:all, :conditions => { :provider => 'yahoo' })[0]['name']
			end
			unless current_user.authorizations.find(:all, :conditions => { :provider => 'google' }).blank?
				@google_name = current_user.authorizations.find(:all, :conditions => { :provider => 'google' })[0]['name']
			end
		end
		@posts = @user.posts.paginate(:page => params[:page], :per_page => 5)
		@post = current_user.posts.build(params[:post])
		@feed_items = current_user.feed.paginate(:page => params[:page], :per_page => 5)
		@status_items = current_user.status_feed.paginate(:page => params[:page], :per_page => 5)
		@messages = @user.inbox
	end
	
	def uploads
		@user = current_user
		@videos = @user.uploads.where("video_file_name IS NOT NULL")
		@audios = @user.uploads.where("audio_file_name IS NOT NULL")
		@images = @user.uploads.where("image_file_name IS NOT NULL")
		@archives = @user.uploads.where("archive_file_name IS NOT NULL")
		
	end
	
	def layout
		@user = current_user
		@background = params[:background]
		@div = params[:divs]
		@font = params[:fonts]
		
		unless @div.nil? || @div.blank?
			div_base = @div[0..5].match(/(..)(..)(..)/)
			r = div_base[1].hex
			g = div_base[2].hex
			b = div_base[3].hex
			#a = ((((@div[6..7]).hex)/255.to_f*100).to_i).to_s
		
			rgba = "#{r},#{g},#{b},0.6"
			i = Magick::Image.new(10,10){self.background_color = "rgba(#{rgba})"}
			i.write("#{RAILS_ROOT}/public/user/images/#{@user.id}-div.png")
			#secondary divs
			lighter_rgba = "#{r},#{g},#{b},0.2"
			li = Magick::Image.new(10,10){self.background_color = "rgba(#{rgba})"}
			li.write("#{RAILS_ROOT}/public/user/images/#{@user.id}-lighter_div.png")
		
			darker_rgba = "#{r},#{g},#{b},0.8"
			di = Magick::Image.new(10,10){self.background_color = "rgba(#{rgba})"}
			di.write("#{RAILS_ROOT}/public/user/images/#{@user.id}-darker_div.png")
		end
		@user.update_attribute(:fonts, @font) unless @font.nil? || @font.blank?
		@user.update_attribute(:background, @background) unless @background.nil? || @background.blank?
		@user.update_attribute(:divs, "/user/images/#{@user.id}-div.png") unless @div.nil? || @div.blank?
		
		if @user.save
			redirect_to account_settings_path
		else
			render 'edit'
		end
	end
	
	def reset_layout
		@user = current_user
		@user.update_attribute(:fonts, '')
		@user.update_attribute(:background, '')
		@user.update_attribute(:divs, '')
	end
	
	def upload_to_facebook
		fbuser = client.selection.me.info!
		bitly = Bitly.new('metatroid', 'R_989b18cb9ba7418ce979bb0aa5b31a71')
		if params[:input] == 'image'
			client.selection.user(fbuser[:id]).feed.publish!(:message => params[:fb_share_text], :picture => params[:fb_url])
		end
		if params[:input] == 'audio'
			url = bitly.shorten(params[:fb_url])
			client.selection.user(fbuser[:id]).feed.publish!(:message => params[:fb_share_text], :link => url.shorten)
		end
		if params[:input] == 'video'
			url = bitly.shorten(params[:fb_url])
			client.selection.user(fbuser[:id]).feed.publish!(:message => params[:fb_share_text], :link => url.shorten)
		end
	end
	def upload_to_twitter
		twitter_array = current_user.authorizations.find(:all, :conditions => { :provider => 'twitter' })[0]
		@token = twitter_array['token']
		@secret = twitter_array['secret']
		Twitter.configure do |config|
			config.consumer_key = 'y1ur5nbJre7OKYBj6qu39g'
			config.consumer_secret = 'erWPi7Nn8scCBs9wuHSi2eswcI7F287pVTCVQ4sr5Y'
			config.oauth_token = @token
			config.oauth_token_secret = @secret
		end
		bitly = Bitly.new('metatroid', 'R_989b18cb9ba7418ce979bb0aa5b31a71')
		url = bitly.shorten(params[:tw_url])
		content = "#{params[:tw_share_text]} #{url.shorten}"
		Twitter.update(content)
	end
end
