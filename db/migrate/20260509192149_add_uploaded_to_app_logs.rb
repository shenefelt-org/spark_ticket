class AddUploadedToAppLogs < ActiveRecord::Migration[8.1]
  def change
    add_column :app_logs, :uploaded, :boolean
  end
end
