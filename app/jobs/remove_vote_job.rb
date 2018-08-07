class RemoveVoteJob < ApplicationJob
  queue_as :default

  # @param [VoteRecord] vote
  def perform(vote)
    # Do something later
    ActionCable.server.broadcast "broadcast_votes", action: 'remove_vote', affiliation_id: vote.affiliation_id, vote: vote.vote, document_id: vote.document_id
  end
end
