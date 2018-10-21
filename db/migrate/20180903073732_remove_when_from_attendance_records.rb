class RemoveWhenFromAttendanceRecords < ActiveRecord::Migration[5.2]
  def change
    remove_column :attendance_records, :when
  end
end
