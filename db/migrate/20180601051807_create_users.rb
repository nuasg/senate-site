class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.belongs_to :affiliation, index: false

      t.integer :role
      t.text :netid

      t.timestamps
    end
  end
end
