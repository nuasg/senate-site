class Document < ApplicationRecord
  has_many :document_links

  has_many :vote_records

  has_many :voting_document_links, -> { where voting: true }, class_name: 'DocumentLink', inverse_of: :document
  has_many :nonvoting_document_links, -> {where voting: false }, class_name: 'DocumentLink', inverse_of: :document

  has_many :voting_meetings, class_name: 'Meeting', through: :voting_document_links, source: :meeting
  has_many :nonvoting_meetings, class_name: 'Meeting', through: :nonvoting_document_links, source: :meeting

  belongs_to :document_type

  accepts_nested_attributes_for :document_links

  before_destroy :kill_doc_links

  validates :name, presence: true

  def type
    document_type
  end

  def type=(val)
    self.document_type = val
  end

  def user_can_vote?(user)
    AttendanceRecord.where(meeting_id: voting_meeting.id, netid: user.netid).count != 0
  end

  def user_voted?(user)
    VoteRecord.where('document_id = ? AND affiliation_id = ? AND vote != 0', self.id, user.affiliation_id).count != 0
  end

  def get_user_vote(user)
    return nil if user.affiliation_id.nil?
    VoteRecord.find_by(document_id: self.id, affiliation_id: user.affiliation_id)
  end

  def vote(affiliation, vote)
    raise 'Voting not open.' unless self.voting_open && self.voting_meeting.open?

    existing = VoteRecord.find_by(affiliation_id: affiliation.id, document_id: self.id)

    if existing.nil?
      VoteRecord.create affiliation_id: affiliation.id, vote: vote, document_id: self.id
    else
      existing.update_attributes vote: vote
    end
  end

  def votes
    [
        ['no_vote', VoteRecord.where(document: self, vote: :no_vote).count],
        ['aye', VoteRecord.where(document: self, vote: :aye).count],
        ['nay', VoteRecord.where(document: self, vote: :nay).count],
        ['abstain', VoteRecord.where(document: self, vote: :abstain).count]
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
    meeting = Meeting.open

    return [] if meeting.nil?

    User.joins "INNER JOIN attendance_records ON attendance_records.netid = users.netid AND attendance_records.status = #{AttendanceRecord.statuses['present']} AND attendance_records.meeting_id = #{meeting.id}"
  end

  def authorized_netids
    authorized_voters.pluck(:netid)
  end

  def voting_link
    DocumentLink.find_by(document: self, voting: true)
  end

  def voting_meeting
    return voting_link.meeting unless voting_link.nil?
    nil
  end

  def can_open_voting?
    Document.open.nil? && !self.voting_meeting.nil? && self.voting_meeting.open? && !self.voting_open?
  end

  def open_voting
    raise 'Voting already open' unless Document.open.nil? || Document.open == self
    raise 'No voting meeting linked' if self.voting_meeting.nil?
    raise 'Voting meeting not open' unless Meeting.open == self.voting_meeting && self.voting_meeting.open?

    self.update_attribute :voting_open, true

    records = []
    authorized_voters.each do |voter|
      records << VoteRecord.new(affiliation: voter.representing, vote: :no_vote, document: self) if VoteRecord.find_by(affiliation: voter.representing, document: self).nil?
    end

    VoteRecord.transaction do
      records.each &:save
    end

    ToggleVotingJob.perform_now self
  end

  def reset_votes
    VoteRecord.where(document: self).delete_all
    close_voting
  end

  def close_voting
    self.update_attribute :voting_open, false

    ToggleVotingJob.perform_now self
  end

  def self.open
    Document.find_by(voting_open: true)
  end

  private
  def kill_doc_links
    DocumentLink.where(document_id: id).delete_all
  end
end
