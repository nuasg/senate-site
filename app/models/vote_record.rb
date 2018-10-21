class VoteRecord < ApplicationRecord
  attr_accessor :old_vote

  belongs_to :affiliation
  belongs_to :document

  enum vote: [:no_vote, :aye, :nay, :abstain]

  before_update :update_old_vote
  after_save :broadcast_vote
  before_destroy :remove_vote

  validates :affiliation_id, uniqueness: {scope: :document_id}

  private
  def update_old_vote
    self.old_vote = self.vote_was
  end

  def broadcast_vote
    BroadcastVoteJob.perform_now self
  end

  def remove_vote
    RemoveVoteJob.perform_now self
  end
end
