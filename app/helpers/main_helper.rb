module MainHelper
  def active_document_id
    @document.nil? ? -1 : @document.id
  end

  def active_document_name
    @document.nil? ? 'Nothing at vote.' : @document.name
  end

  def document_no_votes_height
    @document.nil? ? 0 : height(@document.no_votes)
  end

  def document_ayes_height
    @document.nil? ? 0 : height(@document.ayes)
  end

  def document_nays_height
    @document.nil? ? 0 : height(@document.nays)
  end

  def document_abstains_height
    @document.nil? ? 0 : height(@document.abstains)
  end

  def affiliation_user(affiliation)
    affiliation.user.nil? ? content_tag(:span, 'None', class: 'text-muted') : affiliation.user.name
  end

  private
  def height(part)
    part * 100 / @document.votes_possible
  end
end
