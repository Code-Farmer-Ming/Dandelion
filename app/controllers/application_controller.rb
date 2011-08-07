# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  before_filter :authentication_check
  before_filter :check_session
  SESSION_TIME_OUT=600
  attr_reader :current_user

  #获取 session[:user]的值
  def current_user_id
    current_user && current_user.id
  end



  private


  def check_session

    #    if session[:expires_at] &&
    #        Time.now > session[:expires_at]
    #      reset_session
    #      MsgQueue.clear_by_user(current_user_id)
    #    else
    #      session[:expires_at]= SESSION_TIME_OUT.from_now
    #    end
    #   _session_id=1df52ed345942a4a5ebe94e6248099d9

  end


  def authentication_check
    authenticate_or_request_with_http_basic do |user, password|
      @current_user=User.find_by_email_and_password(user,password)
    end
  end
end
