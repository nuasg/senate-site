class FixUniqueOnMeeting < ActiveRecord::Migration[5.2]
  def change
    remove_index :attendance_records, column: [:meeting_id, :affiliation_id]
    add_index :attendance_records, [:meeting_id, :affiliation_id, :status], unique: true, name: 'unique_meeting_and_time_and_affiliation'
  end
end
