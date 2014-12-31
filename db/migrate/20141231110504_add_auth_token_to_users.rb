class AddAuthTokenToUsers < ActiveRecord::Migration
  def up
    add_column :users, :auth_token, :string

    User.find_each do |user|
      user.auth_token = User.generate_auth_token
      user.save!
    end
  end

  def down
    remove_column :users, :auth_token
  end
end
