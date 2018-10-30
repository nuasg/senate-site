class AddEmbedToMeetings < ActiveRecord::Migration[5.2]
  def change
    add_column :meetings, :embed, :text
  end
end
