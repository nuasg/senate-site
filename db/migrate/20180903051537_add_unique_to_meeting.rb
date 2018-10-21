class AddUniqueToMeeting < ActiveRecord::Migration[5.2]
  def change
    add_index :attendance_records, [:meeting_id, :affiliation_id], unique: true
  end
end
