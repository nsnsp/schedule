class AddEmailVerifiedToIdentities < ActiveRecord::Migration
  def change
    add_column :identities, :email_verified, :boolean
  end
end
