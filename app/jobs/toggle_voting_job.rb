class ToggleVotingJob < ApplicationJob
  queue_as :default

  # @param [Document] document
  def perform(document)
    VoteDisplayChannel.broadcast_to document, action: 'toggle_voting', value: document.voting_open ? "enabled" : "disabled"

    if document.voting_open
      ActionCable.server.broadcast "broadcast_votes", action: 'change_document', new_document: document.id, new_document_name: document.name, votes: document.votes
    else
      ActionCable.server.broadcast "broadcast_votes", action: 'change_document', new_document: -1
    end
  end
end
