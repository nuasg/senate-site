class FixUniqueIndexOnAttendanceRecords < ActiveRecord::Migration[5.2]
  def change
    remove_index :attendance_records, name: 'unique_meeting_and_time_and_affiliation'
    add_index :attendance_records, [:affiliation_id, :meeting_id], unique: true
  end
end
