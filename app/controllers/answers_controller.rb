class AnswersController < ApplicationController
	before_filter :admin_user
	
	def create
		
		@answer = Answer.create(params[:answer])
		if @answer.save
			flash.now[:message] = ''
		else
			flash.now[:message] = ''
		end
	end

end