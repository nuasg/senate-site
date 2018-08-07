module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    protected
    def find_verified_user
      if User.find_by(cookies.signed[:user_id])
        User.find_by(cookies.signed[:user_id])
      else
        reject_unauthorized_connection
      end
    end
  end
end
