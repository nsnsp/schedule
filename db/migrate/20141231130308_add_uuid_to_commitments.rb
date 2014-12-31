class AddUuidToCommitments < ActiveRecord::Migration
  def up
    add_column :commitments, :uuid, :string, length: 36
    add_index :commitments, :uuid, unique: true

    Commitment.find_each do |c|
      c.set_defaults
      c.save!
    end
  end

  def down
    remove_column :commitments, :uuid
  end
end
