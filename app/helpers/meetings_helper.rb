module MeetingsHelper
  def term_url(term)
    url_for controller: :meetings, action: :index, year: term.year, quarter: term.quarter
  end

  def term_options(selected = -1)
    y = Term.all.order(end: :desc).collect do |term|
      [term.name, term.id, {data: {url: term_url(term)}}]
    end

    options_for_select y, selected
  end
end
