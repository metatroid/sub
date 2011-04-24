class ArticlesController < ApplicationController
	
	before_filter :admin_user

	def create
		@article = Article.create(params[:article])
		if @article.save
			flash.now[:message] =''
		else
			flash.now[:message] =''
		end
	end

end