class AddUniqueToVoteRecords < ActiveRecord::Migration[5.2]
  def change
    add_index :vote_records, [:affiliation_id, :document_id], unique: true
  end
end
