class CreateAppLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :app_logs do |t|
      t.string :level
      t.string :method
      t.string :path
      t.string :agent
      t.string :ip_address

      t.timestamps
    end
  end
end
