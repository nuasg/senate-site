class Term < ApplicationRecord
  validates :name, :begin, :end, presence: true

  def meetings
    Meeting.where('date >= ? AND date <= ?', self.begin, self.end).order(date: :desc)
  end

  def year
    name.split[1].to_i
  end

  def quarter
    name.split[0]
  end

  def self.options
    all.map do |term|
      [
        term.name,
        term.id,
        { 'data-url': url_for(controller:   :meetings,
                              action:       :index,
                              year:         term.year,
                              quarter:      term.quarter) }
      ]
    end
  end

  def render

  end

  def context_menu

  end
end
