module TermsHelper
  def term_begin(term)
    term.begin.strftime '%b %-d, %Y'
  end

  def term_end(term)
    term.end.strftime '%b %-d, %Y'
  end

  def term_delete_link(term)
    link_to 'Delete', {controller: :terms, action: :destroy, id: term.id}, method: :delete,
            data: {confirm: 'Are you sure you want to delete this?'}
  end

  def term_edit_link(term)
    link_to 'Edit', controller: :terms, action: :edit, id: term.id
  end
end
