class CreateTicketAssignments < ActiveRecord::Migration[8.1]
  def change
    create_table :ticket_assignments do |t|
      t.references :ticket, null: true, foreign_key: true
      t.references :tech, null: true, foreign_key: true

      t.timestamps
    end
  end
end
