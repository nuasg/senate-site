class ApplicationController < ActionController::Base
  before_action :current_user

  # For logging into the site at all
  def require_active_user
    unless session[:user_id]
      if request.fullpath == '/'
        redirect_to '/login'
      elsif
        redirect_to '/login', alert: 'You must be logged in to perform that action.'
      end
    end
  end

  def require_admin
    user = User.find(session[:user_id])

    unless user.admin
      redirect_to '/', alert: 'You must be an admin to perform that action.'
    end
  end

  def current_user
    @user = User.find_by id: session[:user_id]
    # SELECT * FROM `users` WHERE
  end
end
