class MainController < ApplicationController
  skip_before_action :require_active_user, only: [:login, :logout, :authenticate]

  def login
  end

  def roster
    @affiliations = Affiliation.all.order :affiliation_type_id, :name

    render layout: 'application'
  end

  def logout
    reset_session
    cookies.delete :user_id
    cookies.delete :netid

    show_message text: 'Logged out.', redirect: {controller: :main, action: :login}
  end

  def display
    @document = Document.find_by(voting_open: true)
  end

  def authenticate
    res = User.authenticate params['netid'].downcase, params['password']

    show_message text: res, result: :failure, redirect: {action: :login} and return unless res.is_a? User

    session[:user_id] = res.id
    cookies.signed[:user_id] = res.id
    session[:netid] = res.netid
    cookies.signed[:netid] = res.netid

    redirect_to :root
  end
end
