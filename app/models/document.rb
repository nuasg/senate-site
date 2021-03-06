class Document < ApplicationRecord
  include DocumentsHelper

  has_many :document_links

  has_many :vote_records

  has_many :voting_document_links, -> { where voting: true }, class_name: 'DocumentLink', inverse_of: :document
  has_many :nonvoting_document_links, -> {where voting: false }, class_name: 'DocumentLink', inverse_of: :document

  has_many :voting_meetings, class_name: 'Meeting', through: :voting_document_links, source: :meeting
  has_many :nonvoting_meetings, class_name: 'Meeting', through: :nonvoting_document_links, source: :meeting

  belongs_to :document_type

  accepts_nested_attributes_for :document_links

  before_destroy :kill_doc_links
  after_validation :broadcast_update

  validates :name, presence: true

  def type
    document_type
  end

  def user_vote(user)
    return nil if user.affiliation_id.nil?
    VoteRecord.find_by(document_id: self.id, affiliation_id: user.affiliation_id)
  end

  def vote(user, vote)
    affiliation = user.affiliation

    raise 'Voting not open.' unless self.voting_open && self.voting_meeting.open?
    raise 'Not authorized to vote.' unless user.can_vote_now?(self)

    existing = VoteRecord.find_by(affiliation_id: affiliation.id, document_id: self.id)

    VoteRecord.create affiliation_id: affiliation.id, vote: vote, document_id: self.id if existing.nil?
    existing.update_attributes vote: vote unless existing.nil?

    DocumentVoteJob.perform_now self, document_status(self)
  end

  def votes
    [
        ['no_vote', no_votes],
        ['aye', ayes],
        ['nay', nays],
        ['abstain', abstains]
    ]
  end

  def no_votes
    VoteRecord.where(document: self, vote: :no_vote).length
  end

  def ayes
    VoteRecord.where(document: self, vote: :aye).length
  end

  def nays
    VoteRecord.where(document: self, vote: :nay).length
  end

  def abstains
    VoteRecord.where(document: self, vote: :abstain).length
  end

  def votes_possible
    count = VoteRecord.where(document: self).count
    return count unless count == 0
    1
  end

  def authorized_voters
    authorized_netids.map { |netid| User.find_or_sub netid: netid }
  end

  def authorized_netids
    voting_meeting.attendance_records.where(status: :present).pluck(:netid)
  end

  def voting_link
    DocumentLink.find_by(document: self, voting: true)
  end

  #:@return [Meeting]
  def voting_meeting
    return voting_link.meeting unless voting_link.nil?
    nil
  end

  def open_voting
    raise 'Voting is already open.' unless Document.open.nil? || Document.open == self
    raise 'No voting meeting linked.' if self.voting_meeting.nil?
    raise 'Voting meeting not open.' unless Meeting.open == self.voting_meeting

    records = []
    authorized_voters.each do |voter|
      if VoteRecord.find_by(affiliation: voter.representing, document: self).nil?
        records << VoteRecord.new(affiliation: voter.representing, vote: :no_vote, document: self)
      end
    end

    VoteRecord.transaction do
      records.each &:save
    end

    self.voting_open = true
    save
  end

  def reset_votes
    VoteRecord.where(document: self).delete_all
    close_voting
  end

  def close_voting
    self.voting_open = false
    save
  end

  def self.open
    Document.find_by voting_open: true
  end

  def result
    return 'Not Voted' if self.vote_records.count == 0
    return 'In Progress' if self.voting_open
    return 'Passed' if self.ayes > self.nays
    return 'Failed' if self.ayes <= self.nays
  end

  private
  def kill_doc_links
    DocumentLink.where(document_id: id).delete_all
  end

  def broadcast_update
    if self.voting_open_changed?
      BroadcastDocumentJob.perform_now self
    end
  end
end
