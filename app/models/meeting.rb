class Meeting < ApplicationRecord
  has_many :document_links
  has_many :documents, through: :document_links

  has_many :attendance_records
  has_many :affiliations, through: :attendance_records

  accepts_nested_attributes_for :attendance_records

  def real_name
    if name && name != ''
      name
    else
      if date
        "Senate #{date.strftime "%b %-d, %Y"}"
      else
        "Senate [Date]"
      end
    end
  end

  def term
    Term.find_by "begin < ? and end > ?", self.date, self.date
  end

  def attendance_records(time)
    AttendanceRecord.where(meeting: self, when: time)
  end

  def attendance_record_by_netid(netid)
    AttendanceRecord.find_by(meeting: self, when: :begin, netid: netid)
  end

  def attendance_record_by_affiliation(affiliation)
    AttendanceRecord.find_by(meeting: self, when: :begin, affiliation: affiliation)
  end

  def open
    if Meeting.open
      raise 'Meeting already open'
    end

    self.begin = DateTime.now
    save!

    authorized = User.joins(:affiliation).where('Affiliations.enabled = ?', true)

    attributes = {
        affiliation: nil,
        meeting: self,
        when: :begin,
        status: nil,
        sub: nil,
        late: nil,
        who: nil,
        netid: nil
    }

    authorized.each do |user|
      attributes[:affiliation] = user.affiliation

      exist = AttendanceRecord.find_by(affiliation: user.affiliation, meeting: self, when: :begin)

      if exist.nil?
        AttendanceRecord.create(attributes)
      end
    end
  end

  def voting_documents
    self.document_links.where(voting: true).map do |link|
      link.document
    end
  end

  def nonvoting_documents
    self.document_links.where(voting: false).map do |link|
      link.document
    end
  end

  def open?
    self.begin != nil && self.end.nil?
  end

  def closed?
    self.begin != nil && self.end != nil
  end

  def reset
    self.attendance_records(:begin).each do |a| a.destroy end
    self.attendance_records(:end).each do |a| a.destroy end
    self.begin = nil
    self.end = nil
    save
  end

  def self.open
    Meeting.find_by('begin IS NOT NULL AND end IS NULL')
  end

  def close
    self.end = DateTime.now
    save!

    authorized = User.joins(:affiliation).where('Affiliations.enabled = ?', true)

    attributes = {
        affiliation: nil,
        meeting: self,
        when: :end,
        status: nil,
        sub: nil,
        late: nil,
        who: nil,
        netid: nil
    }

    authorized.each do |user|
      attributes[:affiliation] = user.affiliation

      exist = AttendanceRecord.find_by(affiliation: user.affiliation, meeting: self, when: :end)

      if exist.nil?
        x = AttendanceRecord.create(attributes)
        start = x.get_begin

        x.update(who: start.who, netid: start.netid, sub: x.sub)
      end
    end
  end
end
