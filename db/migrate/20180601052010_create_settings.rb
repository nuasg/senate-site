class CreateSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :settings do |t|
      t.text :name
      t.text :value

      t.timestamps
    end
  end
end
