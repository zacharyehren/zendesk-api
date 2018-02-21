class User < ApplicationRecord
  def self.get_users_from_zen_desk
    User.transaction do
      ZEN_CLIENT.users.per_page(100).all do | user |
        new_user = User.new do |u|
          u.name = user.name
          u.zen_desk_id = user.id
          u.email = user.email
        end
        new_user.save!
      end
    end
  end
end
