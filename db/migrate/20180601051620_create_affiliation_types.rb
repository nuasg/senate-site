class CreateAffiliationTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :affiliation_types do |t|
      t.boolean :enabled
      t.string :name

      t.timestamps
    end
  end
end
