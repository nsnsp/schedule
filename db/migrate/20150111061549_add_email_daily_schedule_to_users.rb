class AddEmailDailyScheduleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :daily_schedule_notification, :boolean, default: false
    add_index :users, :daily_schedule_notification
  end
end
