class AddDescToMeeting < ActiveRecord::Migration[5.2]
  def change
    add_column :meetings, :description, :text
  end
end
