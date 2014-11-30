class CreateIdentities < ActiveRecord::Migration
  def change
    create_table :identities do |t|
      t.references :user, index: true
      t.string :auth0_uid, null: false
      t.string :first_name
      t.string :last_name
      t.string :email
      t.text :image_url

      t.timestamps
    end

    add_index :identities, :auth0_uid, unique: true
  end
end
