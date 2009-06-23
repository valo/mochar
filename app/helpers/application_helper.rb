# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def get_logged_user
    User.find_by_id(session[:logged_user_id])
  end
end
