class AddDefaultToDocumentVotingOpen < ActiveRecord::Migration[5.2]
  def change
    change_column_default :documents, :voting_open, false
  end
end
