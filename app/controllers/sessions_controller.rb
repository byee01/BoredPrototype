class SessionsController < ApplicationController
	def create
		#render :text => request.env['rack.auth'].inspect
		#@andrewID = 
		#unless @auth = User.find_by_andrew_id(@andrew_id)
		#	@auth = User.create
		#	@auth = 
		#end
		#self.current_user = @auth.user
		
		#render :text => "Welcome, #{current_user.name}."
		
		if Rails.env == "production"
			auth = request.env["omniauth.auth"]
			user = User.find_by_andrew_id(auth["uid"])
		else
			user = User.find_by_andrew_id("byee")
		end

		if user.nil?
			user = User.create
			user.andrew_id = auth["uid"]
		else
			reset_session
			session[:user_id] = user.id
			flash[:notice] = "You have been successfully logged in"
			redirect_to request.env['omniauth.origin'] || root_url(:subdomain => "my")
		end
	end
	
	def destroy
    @current_user = nil
    reset_session

    flash[:notice] = "You have been logged out"
    redirect_to root_url(:subdomain => false)
  end
end
