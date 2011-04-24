class MessagesController < ApplicationController

	def new
		@message = Message.new
		@self = current_user
		@user = User.find_by_name(params[:name])
	end

	def create
		@sender = current_user.id.to_i
		@message = Message.create! do |m|
																	m.sender = @sender
																	m.recipient = params[:message][:recipient].to_i
																	m.subject = params[:message][:subject]
																	m.content = params[:message][:content]
																end
		if @message.save
			flash.now[:message] = "success!"
		else
			flash.now[:message] = "failure!"
		end
	end

	def inbox
		@user = current_user
		@messages = @user.inbox
	end
	
	def show
		@user = current_user
		@message = Message.find(:conditions => {:recipent => @user.id})
	end
	
end