class CreateClosedTickets < ActiveRecord::Migration[5.1]
  def change
    create_table :closed_tickets do |t|

      t.timestamps
    end
  end
end
