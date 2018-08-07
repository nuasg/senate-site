class User < ApplicationRecord
  belongs_to :affiliation, optional: true
  before_save :downcase_netid

  def make_sub(name, netid)
    u = User.find_by(netid: netid)

    if u
      u.update(name: name)
    else
      User.create(name: name, netid: netid)
    end
  end

  def representing
    meeting = Meeting.open

    return nil if meeting.nil?

    record = meeting.attendance_record_by_netid netid
    return nil if record.nil?

    record.affiliation
  end

  def rep_name
    representing.nil? ? '' : representing.name
  end

  def self.authenticate
    # TODO: Move Main controller logic here to eliminate fat controller
  end

  private
  def downcase_netid
    netid.downcase!
  end
end
