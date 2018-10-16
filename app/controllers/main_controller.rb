class MainController < ApplicationController
  def login
  end

  def roster
    @affiliations = Affiliation.all.order(affiliation_type_id: :asc).order(name: :asc)

    render layout: 'application'
  end

  def logout
    reset_session
    cookies.delete :user_id

    flash[:alert] = 'Logged out.'

    redirect_to controller: 'main', action: 'login'
  end

  def display
    @document = Document.find_by(voting_open: true)
  end

  def authenticate
    res = User.authenticate(params['netid'], params['password'])

    if res.is_a? Integer
      session[:user_id] = res
      cookies.signed[:user_id] = res

      if session[:last]
        redirect_to session[:last]
      else
        redirect_to :root
      end
    else
      flash[:alert] = res

      redirect_to action: :login
    end
  end
end
