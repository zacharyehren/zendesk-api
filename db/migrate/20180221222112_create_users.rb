class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.integer :zen_desk_id, limit: 8
      t.timestamps
    end
  end
end
