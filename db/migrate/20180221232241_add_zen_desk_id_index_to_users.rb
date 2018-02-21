class AddZenDeskIdIndexToUsers < ActiveRecord::Migration[5.1]
  def change
    add_index :users, :zen_desk_id, unique: true
  end
end
