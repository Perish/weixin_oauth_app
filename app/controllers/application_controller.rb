class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception


  def require_login
  	if current_user.blank?
  		redirect_to login_path
  	end
  end

  def is_login?
  	!current_user.blank?
  end


  def current_user
  	User.find_by(name: session[:name])
  end
end
