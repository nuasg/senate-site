class BroadcastVoteJob < ApplicationJob
  queue_as :default

  def perform(vote, old_vote)
    ActionCable.server.broadcast "broadcast_votes", action: 'receive_vote', affiliation_id: vote.affiliation_id, vote: vote.vote, document_id: vote.document_id, old_vote: old_vote
  end
end
