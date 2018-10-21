class BroadcastVoteJob < ApplicationJob
  queue_as :default

  def perform(vote)
    ActionCable.server.broadcast 'voting', action: 'receive_vote', affiliation_id: vote.affiliation_id, vote: vote.vote, document_id: vote.document_id, old_vote: vote.old_vote
  end
end
