class CreateMeetings < ActiveRecord::Migration[5.2]
  def change
    create_table :meetings do |t|
      t.datetime :begin
      t.datetime :end
      t.text :name
      t.text :agenda
      t.text :minutes
      t.date :date

      t.timestamps
    end
  end
end
