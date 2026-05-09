class CreateTicketResponses < ActiveRecord::Migration[8.1]
  def change
    create_table :ticket_responses do |t|
      t.references :ticket, null: false, foreign_key: true
      t.references :tech, null: false, foreign_key: true
      t.text :message

      t.timestamps
    end
  end
end
