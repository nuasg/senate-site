class User < ApplicationRecord
  belongs_to :affiliation, optional: true

  validates :name, :netid, presence: true

  before_save :downcase_netid

  def self.admin?(id)
    id && User.find(id).admin
  end

  def make_sub(name, netid)
    u = User.find_by(netid: netid)

    if u
      u.update_attributes(name: name)
    else
      User.create(name: name, netid: netid)
    end
  end

  def representing
    meeting = Meeting.open

    unless meeting.nil?
      record = meeting.attendance_record_by_netid netid

      unless record.nil?
        return record.affiliation
      end
    end

    return self.affiliation
  end

  def rep_name
    representing.nil? ? '' : representing.name
  end

  def self.authenticate(netid, password)
    if Rails.env.development?
      user = User.find_by netid: netid.downcase
      user.nil? ? 'Your username does not yet exist in the database. Please see the Speaker of the Senate.' : user.id
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
      return exist.id
    end
  end

  private
  def downcase_netid
    netid.downcase!
  end
end
