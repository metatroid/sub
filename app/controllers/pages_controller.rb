class PagesController < ApplicationController
  def home
		@title = "Home"
  end

  def contact
		@title = "Contact"
  end
  
  def about
		@title = "About"
  end
	
	def news
		@title = "News"
		@article = Article.new
		@articles = Article.find(:all, :order => 'id DESC')
	end
  
  def help
		@title = "Help"
		@question = Question.new
		@questions = Question.find(:all, :order => 'id DESC' )
		@answer = Answer.new
  end
	
	def send_mail
		Notifications.deliver_contactme(params[:email])
		flash[:notice] = 'email sent'
		redirect_to '/contact'
	end
	
		
end
