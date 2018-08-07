class Document < ApplicationRecord
  has_many :document_links
  has_many :meetings, through: :document_links

  belongs_to :document_type

  def type
    document_type
  end

  def type=(val)
    self.document_type = val
  end

  def vote(affiliation, vote)
    existing = VoteRecord.find_by(affiliation: affiliation, document: self)

    if existing.nil?
      VoteRecord.create affiliation: affiliation, vote: vote, document: self
    else
      existing.update vote: vote
    end
  end

  def votes
    x = VoteRecord.where(document: self)

    ret = {
        no_vote: 0,
        aye: 0,
        nay: 0,
        abstain: 0
    }

    x.each do |y|
      ret[y.vote.to_sym] += 1
    end

    [["no_vote", ret[:no_vote]],["aye", ret[:aye]],["nay", ret[:nay]],["abstain", ret[:abstain]]]
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
    VoteRecord.where(document: self).length unless VoteRecord.where(document: self).length == 0
    1
  end

  def authorized_voters
    meeting = Meeting.open

    return [] if meeting.nil?

    records = meeting.attendance_records :begin

    voters = []

    records.each do |record|
      if record.status == :present.to_s
        voters.push User.find_by(netid: record.netid)
      end
    end

    voters
  end

  def voting_link
    DocumentLink.find_by(document: self, voting: true)
  end

  def voting_meeting
    voting_link.meeting unless voting_link.nil?
    nil
  end

  def open_voting
    raise 'Voting already open' unless Document.open.nil? || Document.open == self
    raise 'No voting meeting linked' if self.voting_meeting.nil?
    raise 'Voting meeting not open' unless Meeting.open == self.voting_meeting && self.voting_meeting.open?

    self.update voting_open: true

    ToggleVotingJob.perform_now self

    voters = authorized_voters
    voters.each do |voter|
      VoteRecord.create(affiliation: voter.representing, vote: :no_vote, document: self) if VoteRecord.find_by(affiliation: voter.representing, document: self).nil?
    end
  end

  def reset_votes
    VoteRecord.where(document: self).each do |vr| vr.destroy end
  end

  def close_voting
    self.voting_open = false
    save

    ToggleVotingJob.perform_now self
  end

  def self.open
    Document.find_by(voting_open: true)
  end
end
