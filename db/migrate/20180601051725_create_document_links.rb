class CreateDocumentLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :document_links do |t|
      t.belongs_to :document
      t.belongs_to :meeting

      t.boolean :voting
      t.integer :order

      t.timestamps
    end
  end
end
