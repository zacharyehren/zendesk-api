class CreateMyTickets < ActiveRecord::Migration[5.1]
  def change
    create_table :my_tickets do |t|

      t.timestamps
    end
  end
end
