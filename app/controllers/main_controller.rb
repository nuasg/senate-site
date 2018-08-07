class MainController < ApplicationController
  def login
  end

  def logout
    reset_session

    flash[:alert] = 'Logged out.'

    redirect_to controller: 'main', action: 'login'
  end

  def display
    @document = Document.find_by(voting_open: true)
  end

  def authenticate
    if Rails.env.development?
      exist = User.find_by(netid: params['netid'].downcase)

      if exist.nil?
        flash[:alert] = 'Your username does not yet exist in the database. Please see the Speaker of the Senate.'
        redirect_to '/login' and return
      else
        session[:user_id] = exist.id
      end

      redirect_to '/' and return
    end

    @ldap = Net::LDAP.new(
        host: NetID::Auth::HOST,
        port: NetID::Auth::PORT,
        encryption: {
            method: :simple_tls,
            tls_options: OpenSSL::SSL::SSLContext::DEFAULT_PARAMS
        },
        auth: {
            method: :simple,
            username: NetID::Auth::USER,
            password: NetID::Auth::PASSWORD
        },
        base: 'dc=northwestern,dc=edu'
    )
    @ldap.host = NetID::Auth::HOST
    @ldap.port = NetID::Auth::PORT

    bound = false

    begin
      bound = @ldap.bind
    rescue
      flash[:alert] = 'Internal authentication error.'

      redirect_to '/login' and return
    end

    unless bound
      flash[:alert] = 'Internal authentication error.'

      redirect_to '/login' and return
    end

    filter = Net::LDAP::Filter.eq('uid', params['netid'].downcase)

    @res = @ldap.search(filter: filter)

    if @res.nil? || @res.empty?
      flash[:alert] = 'Invalid NetID.'

      redirect_to '/login' and return
    end

    @ldap.auth @res[0][:dn], params['password']

    begin
      bound = @ldap.bind
    rescue
      flash[:alert] = 'Internal authentication error.'

      redirect_to '/login' and return
    end

    unless bound
      flash[:alert] = 'Invalid NetID password.'

      redirect_to '/login' and return
    end

    exist = User.find_by(netid: params['netid'].downcase)

    if exist.nil?
      flash[:alert] = 'Your username does not yet exist in the database. Please see the Speaker of the Senate.'
      redirect_to '/login' and return
    else
      session[:user_id]         = exist.id
      cookies.signed[:user_id]  = exist.id
    end

    if !session[:last]
      redirect_to '/'
    else
      redirect_to session[:last]
    end
  end
end
