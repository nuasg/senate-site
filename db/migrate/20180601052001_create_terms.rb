class CreateTerms < ActiveRecord::Migration[5.2]
  def change
    create_table :terms do |t|
      t.text :name
      t.date :begin
      t.date :end

      t.timestamps
    end
  end
end
