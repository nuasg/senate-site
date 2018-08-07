class CreateAttendanceRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :attendance_records do |t|
      t.belongs_to :affiliation
      t.belongs_to :meeting

      t.text :who
      t.text :netid
      t.integer :when
      t.integer :status
      t.boolean :sub
      t.boolean :late

      t.timestamps
    end
  end
end
