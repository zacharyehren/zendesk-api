namespace :data do
  desc "Update user database from ZenDesk API"
  task update_users: :environment do
    User.sync_users_from_zen_desk
  end
end
