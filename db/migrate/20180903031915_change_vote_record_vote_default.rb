class ChangeVoteRecordVoteDefault < ActiveRecord::Migration[5.2]
  def change
    change_column_default :vote_records, :vote, VoteRecord.votes['no_vote']
  end
end
