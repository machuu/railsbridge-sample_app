module SessionsHelper

  # Log in the given user
  def log_in(user)
    session[:user_id] = user.id
  end

  # Returns logged in user, or 'nil'
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  # Evaluate if a login session exists
  def logged_in?
    !current_user.nil?
  end

  # Log out the current user
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
