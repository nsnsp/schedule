class AddEarlyScheduleNotificationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :early_schedule_notification, :string, default: false
    add_index :users, :early_schedule_notification
  end
end
