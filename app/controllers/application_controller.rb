class ApplicationController < ActionController::Base
  before_action :current_user, :require_active_user

  # For logging into the site at all
  def require_active_user
    unless session[:user_id] || session[:netid] && User.find_or_sub(id: session[:user_id], netid: session[:netid])
      reset_session
      cookies.delete :user_id
      cookies.delete :netid

      if request.fullpath == '/'
        redirect_to controller: :main, action: :login
      else
        show_message text: 'You must be logged in to perform that action.', result: 'failure', redirect: {controller: :main, action: :login}
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
    @user = User.find_or_sub id: session[:user_id], netid: session[:netid]
  end

  protected
  def show_error(e)
    puts e.message
    puts e.backtrace.join "\n"

    if request.xhr?
      render json: {result: 'failure', message: e.message}
    else
      flash[:alert] = e.message
      redirect_back fallback_location: {controller: :meetings, action: :index}
    end
  end

  def show_message(text:, redirect: nil, result: 'success')
    if request.xhr?
      render json: {result: result.to_s, message: text}
    else
      flash[:alert] = text

      redirect_back fallback_location: {controller: :message, action: :index} if redirect.nil?
      redirect_to redirect
    end
  end
end
