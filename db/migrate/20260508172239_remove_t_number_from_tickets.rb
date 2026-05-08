class RemoveTNumberFromTickets < ActiveRecord::Migration[8.1]
  def change
    remove_column :tickets,:t_number, :integer
  end
end
