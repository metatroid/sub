class QuestionsController < ApplicationController
	def create
		@question = Question.create(params[:question])
		if @question.save
			flash.now[:message] = ''
		else
			flash.now[:message] = ''
		end
	end
end