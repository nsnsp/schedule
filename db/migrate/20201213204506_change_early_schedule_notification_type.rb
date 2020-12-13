class ChangeEarlyScheduleNotificationType < ActiveRecord::Migration
  def change
    remove_index :users, :early_schedule_notification
    remove_column :users, :early_schedule_notification

    add_column :users, :early_schedule_notification, :boolean, default: false
    add_index :users, :early_schedule_notification
  end
end
