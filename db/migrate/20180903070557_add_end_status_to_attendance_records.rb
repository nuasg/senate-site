class AddEndStatusToAttendanceRecords < ActiveRecord::Migration[5.2]
  def change
    add_column :attendance_records, :end_status, :integer
  end
end
