module TermsHelper
  def render_term(term)
    content_tag :div, class: 'item-listing' do
      concat(content_tag(:div, content_tag(:span, term.name), class: 'title'))
      concat(content_tag(:div, class: 'middle') do
        concat(content_tag(:span) do
          concat term.begin.strftime '%b %-d, %Y'
          concat ' -> '
          concat term.end.strftime '%b %d, %Y'
        end)
      end)
      concat content_tag :div, context_menu, class: 'options'
      concat term_context_menu term
    end
  end

  def term_context_menu(term)
    content_tag :div, class: 'context-menu' do
      content_tag :ul do
        concat(content_tag :li, link_to('Edit', controller: :terms, action: :edit, id: term.id))
        concat(content_tag :li, link_to( 'Delete', {controller: :terms, action: :destroy, id: term.id}, method: :delete, data: {confirm: 'Are you sure you want to delete this?'}))
      end
    end
  end
end
