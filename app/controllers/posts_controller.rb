class PostsController < ApplicationController
	before_filter :require_user
	
	def create
		@post = current_user.posts.build(params[:post])
		@feed_items = current_user.feed.paginate(:page => params[:page], :per_page => 5)
		@status_items = current_user.status_feed.paginate(:page => params[:page], :per_page => 5)
		if @post.save
			flash[:message] = ""
		else
			@feed_items = []
			flash[:error] = ""
		end
	end
	
	def destroy
		Post.find(params[:id]).destroy
	end
end