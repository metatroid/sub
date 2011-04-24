class ApplicationController < ActionController::Base
  protect_from_forgery
	
	def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end

  def signed_in?
    !!current_user
  end

  helper_method :current_user, :signed_in?

  def current_user=(user)
    @current_user = user
    session[:user_id] = user.id
  end
	
	def require_user
      unless current_user
        store_location
        flash[:notice] = "You must be logged in to access this page"
        redirect_to root_path
        return false
      end
  end
	
	
	def admin_user
		redirect_to(root_path) unless current_user.admin?
	end
		
	def store_location
      session[:return_to] = request.request_uri
  end
	
	def client
		@client ||= FBGraph::Client.new(:client_id => '115731095161187',
																		:secret_id => '4e65bf43814cc2a2c836dc6a38bbdd22',
																		:token => current_user.authorizations.find(:all, :conditions => { :provider => 'facebook' })[0]['token'])
	end
	
	def profile_client
		@client ||= FBGraph::Client.new(:client_id => '115731095161187',
																		:secret_id => '4e65bf43814cc2a2c836dc6a38bbdd22',
																		:token => @user.authorizations.find(:all, :conditions => { :provider => 'facebook' })[0]['token'])
	end
	
	
end
