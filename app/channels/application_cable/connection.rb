module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = User.find_by(id: cookies.signed['user.id']) || reject_unauthorized_connection
      logger.add_tags 'ActionCable', current_user.email
    end

  end
end
