class CreateAffiliations < ActiveRecord::Migration[5.2]
  def change
    create_table :affiliations do |t|
      t.belongs_to :affiliation_type

      t.boolean :enabled
      t.string :name

      t.timestamps
    end
  end
end
