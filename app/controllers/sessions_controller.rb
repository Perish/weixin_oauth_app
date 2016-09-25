class SessionsController < ApplicationController
	def new
	end

	def create
		user = User.find_by(name: params[:name])
		if user && user.password == params[:password]
			session[:name] = user.name
			redirect_to links_path
		else
			render 'new'
		end
	end
end
