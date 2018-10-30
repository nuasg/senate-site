class Term < ApplicationRecord
  validates :name, :begin, :end, presence: true

  def year
    name.split[1].to_i
  end

  def quarter
    name.split[0]
  end
end
