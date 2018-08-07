class AttendanceRecord < ApplicationRecord
  belongs_to :affiliation
  belongs_to :meeting

  enum when: [:begin, :end]
  enum status: [:present, :absent]

  def get_begin
    if self.when == :begin
      return nil
    end

    AttendanceRecord.find_by(affiliation: affiliation, meeting: meeting, when: :begin)
  end

  def get_end
    if self.when == :end
      return nil
    end

    AttendanceRecord.find_by(affiliation: affiliation, meeting: meeting, when: :end)
  end

  def is_begin?
    self.when == :begin
  end

  def is_end?
    self.when == :end
  end

  def begin_was_sub?
    if self.when == :begin
      return nil
    end

    prev = AttendanceRecord.find_by(affiliation: affiliation, meeting: meeting, when: :begin)

    prev.sub
  end

  def begin_sub_info
    if self.when == :begin || !begin_was_sub?
      return nil
    end

    prev = AttendanceRecord.find_by(affiliation: affiliation, meeting: meeting, when: :begin)

    [prev.who, prev.netid]
  end

  def humanize
    start = is_begin? ? self : get_begin
    close = is_end? ? self : get_end

    return "Meeting not yet opened." if start.nil?

    if start.status == "present"
      if start.late
        if close.nil? || close.status == "present"
          "Present (Late)"
        else
          "Present (Late, Left Early)"
        end
      else
        if close.nil? || close.status == "present"
          "Present"
        else
          "Present (Left Early)"
        end
      end
    else
      "Absent"
    end
  end
end
