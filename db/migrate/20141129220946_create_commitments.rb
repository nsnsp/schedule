class CreateCommitments < ActiveRecord::Migration
  def change
    create_table :commitments do |t|
      t.references :user, index: true
      t.date :date, null: false
      t.string :type, null: false # abstract

      t.timestamps
    end
    add_index :commitments, :date
    add_index :commitments, :type
  end
end
