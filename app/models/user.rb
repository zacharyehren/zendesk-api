class User < ApplicationRecord
  def self.sync_users_from_zen_desk
    User.transaction do
      ZEN_CLIENT.users.per_page(100).all do | zen_desk_user |
        user_params = {
          name: zen_desk_user.name,
          zen_desk_id: zen_desk_user.id,
          email: zen_desk_user.email
        }
        user = User.find_or_initialize_by(user_params)
        user.save!
      end
    end
  end
end
