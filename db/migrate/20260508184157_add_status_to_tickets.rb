class AddStatusToTickets < ActiveRecord::Migration[8.1]
  def change
    add_column :tickets, :status, :string
    add_column :tickets, :priority, :string
  end
end
