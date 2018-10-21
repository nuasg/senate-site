class VoteRecord < ApplicationRecord
  attr_accessor :old_vote

  belongs_to :affiliation
  belongs_to :document

  enum vote: [:no_vote, :aye, :nay, :abstain]

  before_update :update_old_vote

  validates :affiliation_id, uniqueness: {scope: :document_id}

  private
  def update_old_vote
    self.old_vote = self.vote_was
  end
end
