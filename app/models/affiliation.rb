class Affiliation < ApplicationRecord
  belongs_to :affiliation_type
  has_one :user

  accepts_nested_attributes_for :user

  def type
    affiliation_type
  end

  def enabled?
    enabled && type.enabled
  end

  def dissociate
    User.where(affiliation: self).each do |u|
      u.update(affiliation: nil)
    end
  end

  def self.active
    self.joins(:users).where('Affiliation.enabled = ?', true).order(affiliation_type: :asc)
  end
end
