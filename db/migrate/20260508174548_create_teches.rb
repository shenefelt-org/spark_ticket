class CreateTeches < ActiveRecord::Migration[8.1]
  def change
    create_table :teches do |t|
      t.string :first_name
      t.string :last_name
      t.string :role
      t.integer :employee_id

      t.timestamps
    end
  end
end
