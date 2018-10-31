class User < ApplicationRecord
  belongs_to :affiliation, optional: true

  validates :name, :netid, presence: true

  before_save :downcase_netid
  before_destroy :verify_not_logged

  #@param [Document] document
  def can_vote_now?(document)
    voting_meeting = document.voting_meeting

    has_voting_meeting = !voting_meeting.nil?
    voting_meeting_open = voting_meeting.open?
    present_at_meeting = voting_meeting.netid_present? self.netid
    not_admin = !self.admin
    voting_open = document.voting_open

    has_voting_meeting &&
        voting_meeting_open &&
        present_at_meeting &&
        not_admin &&
        voting_open
  end

  def self.admin?(id)
    User.find_by(id: id)&.admin
  end

  def representing
    meeting = Meeting.open

    unless meeting.nil?
      record = meeting.attendance_record_by_netid netid

      unless record.nil?
        return record.affiliation
      end
    end

    self.affiliation
  end

  def rep_name
    representing.nil? ? '' : representing.name
  end

  def self.find_or_sub(id: nil, netid: '')
    user = User.where('id = ? OR netid = ?', id, netid).first

    return user unless user.nil?
    return User.sub netid
  end

  def self.sub(netid)
    return nil if netid == '' || netid.nil?

    meeting = Meeting.open

    record = meeting&.sub_record netid
    return nil if record.nil?

    User.new name: record.who, netid: record.netid, affiliation: record.affiliation, affiliation_id: record.affiliation_id
  end

  def self.authenticate(netid, password)
    if Rails.env.development?
      user = User.find_or_sub netid: netid.downcase

      if user.nil?
        return 'Your account has not yet been created. Please see the Speaker of the Senate.'
      else
        return user
      end
    else
      return authenticate_ldap netid, password
    end
  end

  def self.authenticate_ldap(netid, password)
    ldap = Net::LDAP.new(
        host: NetID::Auth::HOST,
        port: NetID::Auth::PORT,
        encryption: {
            method: :simple_tls,
            tls_options: OpenSSL::SSL::SSLContext::DEFAULT_PARAMS
        },
        auth: {
            method: :simple,
            username: NetID::Auth::USER,
            password: NetID::Auth::PASSWORD
        },
        base: 'dc=northwestern,dc=edu'
    )

    bound = false

    begin
      bound = ldap.bind
    rescue
      return 'Internal authentication error.'
    end

    unless bound
      return 'Internal authentication error.'
    end

    filter = Net::LDAP::Filter.eq('uid', netid.downcase)

    res = ldap.search filter: filter

    if res.nil? || res.empty?
      return 'Invalid NetID.'
    end

    ldap.auth res[0][:dn], password

    begin
      bound = ldap.bind
    rescue
      return 'Internal authentication error.'
    end

    unless bound
      return 'Invalid NetID password.'
    end

    exist = User.find_by netid: netid.downcase

    if exist.nil?
      return 'Your username does not yet exist in the database. Please see the Speaker of the Senate.'
    else
      return exist
    end
  end

  private
  def downcase_netid
    netid.downcase!
  end

  def verify_not_logged
    raise 'You cannot delete yourself.' if @user.id == self.id
  end
end
