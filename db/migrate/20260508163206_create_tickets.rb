class CreateTickets < ActiveRecord::Migration[8.1]
  def change
    create_table :tickets do |t|
      t.integer :t_number
      t.string :subject
      t.string :body

      t.timestamps
    end
  end
end
