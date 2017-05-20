class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  #before_action :authenticate_person!

  rescue_from CanCan::AccessDenied, :with => :authorization_error

  def authenticate_person!
    redirect_to "/auth/registr" unless current_user
  end

  def current_user
    session[:person]
  end
  helper_method :current_user
end
