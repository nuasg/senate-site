class CreateDocuments < ActiveRecord::Migration[5.2]
  def change
    create_table :documents do |t|
      t.belongs_to :document_type

      t.text :link
      t.text :name
      t.boolean :voting_open

      t.timestamps
    end
  end
end
