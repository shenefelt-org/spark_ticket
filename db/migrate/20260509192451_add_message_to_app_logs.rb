class AddMessageToAppLogs < ActiveRecord::Migration[8.1]
  def change
    add_column :app_logs, :message, :text
  end
end
