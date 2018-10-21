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

  def meeting_context_menu(meeting)
    content_tag :div, class: 'context-menu' do
      content_tag :ul do
        concat(content_tag :li, link_to('Edit', controller: :meetings, action: :edit, id: meeting.id))
        concat(content_tag :li, link_to( 'Delete', {controller: :meetings, action: :destroy, id: meeting.id}, method: :delete, data: {confirm: 'Are you sure you want to delete this?'}))
      end
    end
  end
end
