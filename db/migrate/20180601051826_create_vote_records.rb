class CreateVoteRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :vote_records do |t|
      t.belongs_to :affiliation
      t.belongs_to :document

      t.integer :vote

      t.timestamps
    end
  end
end
