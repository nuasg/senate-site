class AttendanceRecord < ApplicationRecord
  belongs_to :affiliation
  belongs_to :meeting

  enum status: [:present, :absent], _prefix: true
  enum end_status: [:present, :absent], _prefix: true

  validates :who, :netid, presence: true, if: :has_active_status?
  validates :affiliation_id, uniqueness: {scope: :meeting_id}

  def affiliation_and_name
    if self.affiliation&.user.nil?
      self.affiliation&.name
    else
      "#{affiliation.name} (#{affiliation.user.name})"
    end
  end

  def humanize
    return 'Meeting not yet opened.' if meeting.begin.nil?

    if status == 'present'
      if late
        if end_status.nil? || end_status == 'present'
          'Present (Late)'
        elsif end_status == 'absent'
          'Present (Late, Left Early)'
        end
      else
        if end_status.nil? || end_status == 'present'
          'Present'
        elsif end_status == 'absent'
          'Present (Left Early)'
        end
      end
    else
      'Absent'
    end
  end

  def has_active_status?
    self.status == :present
  end

  def current_or_default_who
    if !who.nil? && who != ''
      who
    else
      if affiliation.user.nil?
        ''
      else
        affiliation.user.name
      end
    end
  end

  def current_or_default_netid
    if !netid.nil? && netid != ''
      netid
    else
      if affiliation.user.nil?
        ''
      else
        affiliation.user.netid
      end
    end
  end

  def self.statuses_for_select
    self.statuses.keys.map do |n|
      [n.capitalize, n]
    end
  end

  def self.end_statuses_for_select
    self.end_statuses.keys.map do |n|
      [n.capitalize, n]
    end
  end
end
