class RemoveVotableFromDocumentType < ActiveRecord::Migration[5.2]
  def change
    remove_column :document_types, :votable
  end
end
