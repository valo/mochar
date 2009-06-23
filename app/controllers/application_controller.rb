# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  protected
    def get_logged_user
      User.find_by_id(session[:logged_user_id])
    end
    
    def logoff_user
      session[:logged_user_id] = nil
    end
    
    def require_logged_user
      redirect_to :action => :login unless get_logged_user
    end
end
