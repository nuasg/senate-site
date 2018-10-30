class Meeting < ApplicationRecord
  has_many :document_links, inverse_of: :meeting
  has_many :documents, through: :document_links

  has_many :attendance_records
  has_many :affiliations, through: :attendance_records

  accepts_nested_attributes_for :attendance_records

  before_destroy :destroy_links

  def real_name
    if name && name != ''
      name
    else
      if date
        "Senate #{date.strftime "%b %-d, %Y"}"
      else
        'Senate [Date]'
      end
    end
  end

  def term
    Term.find_by 'begin < ? and end > ?', self.date, self.date
  end

  def has_sub?(netid)
    attendance_records.where(netid: netid).any?
  end

  #@return [AttendanceRecord]
  def sub_record(netid)
    attendance_records.find_by netid: netid
  end

  def attendance_record_by_netid(netid)
    AttendanceRecord.find_by(meeting: self, netid: netid)
  end

  def netid_present?(netid)
    record = attendance_record_by_netid netid

    record&.status == :present
  end

  def open
    if Meeting.open
      raise 'Meeting already open'
    end

    self.update_attributes begin: DateTime.now

    authorized = Affiliation.where(enabled: true).pluck(:id)

    records = []
    authorized.each do |aff|
      records << AttendanceRecord.new(meeting_id: self.id, affiliation_id: aff)
    end

    AttendanceRecord.transaction do
      records.each &:save
    end
  end

  def voting_documents
    Document.joins("INNER JOIN document_links ON document_links.document_id = documents.id AND document_links.meeting_id = #{self.id} AND document_links.voting = 1")
  end

  def nonvoting_documents
    Document.joins("INNER JOIN document_links ON document_links.document_id = documents.id AND document_links.meeting_id = #{self.id} AND document_links.voting = 0")
  end

  def open?
    self.begin != nil && self.end.nil?
  end

  def closed?
    self.begin != nil && self.end != nil
  end

  def reopen
    self.update_attributes end: nil
    AttendanceRecord.where(meeting_id: self.id).update_all end_status: nil
  end

  def reset
    AttendanceRecord.where(meeting_id: self.id).delete_all
    self.update_attributes begin: nil, end: nil
  end

  #@return [Meeting]
  def self.open
    Meeting.find_by('begin IS NOT NULL AND end IS NULL')
  end

  def close
    self.update! end: DateTime.now
  end

  private
  def destroy_links
    DocumentLink.where(meeting_id: self.id).delete_all
  end
end
