class AddMigratedColumnToTickets < ActiveRecord::Migration[8.1]
  def change
    add_column :tickets, :uploaded, :boolean, default: false, null: true
  end
end
