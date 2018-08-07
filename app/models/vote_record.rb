class VoteRecord < ApplicationRecord
  attr_accessor :old_vote

  belongs_to :affiliation
  belongs_to :document

  enum vote: [:no_vote, :aye, :nay, :abstain]

  before_update :update_old_vote
  after_save :broadcast_vote
  before_destroy :remove_vote

  private
  def update_old_vote
    self.old_vote = self.vote
  end

  def broadcast_vote
    BroadcastVoteJob.perform_now self, old_vote
  end

  def remove_vote
    RemoveVoteJob.perform_now self
  end
end
