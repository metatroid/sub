class SessionsController < ApplicationController
	def create
		@user = current_user unless current_user.nil?
		auth = request.env['rack.auth']
		unless @auth = Authorization.find_from_hash(auth)
			# Create a new user or add an auth to existing user, depending on
			# whether there is already a user signed in.
			@auth = Authorization.create_from_hash(auth, current_user)
		end
		# Log the authorizing user in.
		self.current_user = @auth.user
		if @user && (@user.email.blank? || @user.email.nil?)
			@user.update_attribute(:email, request.env['rack.auth']['user_info']['email']) unless request.env['rack.auth']['user_info']['email'].nil? || @user.nil?
		end
		flash[:notice] = "Welcome, #{current_user.name}."
		if cookies[:login_provider].nil? || cookies[:login_provider].blank?
			cookies[:login_provider] = request.env['rack.auth']['provider']
		else
			cookies[:login_provider] += ' '+request.env['rack.auth']['provider']
		end
		redirect_to account_path
	end
	
	def destroy
		session[:user_id] = nil
    flash[:notice] = "Logout successful"
    redirect_to root_path
	end

	
end
