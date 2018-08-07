class ChangeMeetingsBeginEndType < ActiveRecord::Migration[5.2]
  def change
    change_column :meetings, :begin, :time
    change_column :meetings, :end, :time
  end
end
