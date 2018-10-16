module DocumentsHelper
  # @param [Document] doc
  def render_document(doc, voting = false)
    content_tag :div, class: 'item-listing', data: {document_id: doc.id} do
      concat(content_tag(:div, content_tag(:span, link_to(doc.name, doc.link)), class: 'title'))
      if voting
        if is_admin?                                                        # 1
          if doc.voting_meeting.open?                                       # 5
            if doc.voting_open                                              # 3
              _document_admin_rc doc                                # 6
            else
              _document_admin_osr doc                               # 5
            end
          else
            _document_admin_r doc                                   # 4
          end
          else
          if doc.user_can_vote? @user                                       # 2
            if doc.user_voted?(@user)                                       # 4
              _document_user_vote doc                               # 1
            else
              if doc.voting_open                                            # 3
                _document_voting_options_m doc                      # 3
              else
                _document_voting_options_i doc                      # 2
              end
            end
          else
            _document_nothing                                       # 0
          end
        end
      else
        _document_nothing                                           # 0
      end
      if is_admin?
        concat(content_tag(:div, context_menu, class: 'options'))
        concat(document_context_menu doc)
      end
    end
  end

  def _document_nothing
    content_tag :div, class: 'middle'
  end

  # TODO: Select vote using client-side JS instead of server-side DOM replacement

  def _document_user_vote(doc)
    if request.xhr?
      content_tag(:div,
                  content_tag(:div, class: 'voting') do
                    concat(button_to('Aye', {controller: :documents, action: :vote, vote: :aye, id: doc.id, class: doc.get_user_vote(@user).vote == :aye ? 'selected' : ''}, {remote: true}))
                    concat(button_to('Nay', {controller: :documents, action: :vote, vote: :nay, id: doc.id, class: doc.get_user_vote(@user).vote == :nay ? 'selected' : ''}, {remote: true}))
                    concat(button_to('Abstain', {controller: :documents, action: :vote, vote: :abstain, id: doc.id, class: doc.get_user_vote(@user).vote == :abstain ? 'selected' : ''}, {remote: true}))
                  end,
                  class: 'middle')
    else
      concat(content_tag(:div,
                         content_tag(:div, class: 'voting') do
                           concat(button_to('Aye', {controller: :documents, action: :vote, vote: :aye, id: doc.id, class: doc.get_user_vote(@user).vote == :aye ? 'selected' : ''}, {remote: true}))
                           concat(button_to('Nay', {controller: :documents, action: :vote, vote: :nay, id: doc.id, class: doc.get_user_vote(@user).vote == :nay ? 'selected' : ''}, {remote: true}))
                           concat(button_to('Abstain', {controller: :documents, action: :vote, vote: :abstain, id: doc.id, class: doc.get_user_vote(@user).vote == :abstain ? 'selected' : ''}, {remote: true}))
                         end,
                         class: 'middle'))
    end

  end

  def _document_voting_options_i(doc)
    if request.xhr?
      content_tag(:div, class: 'middle') do
        concat(content_tag(:div, {class: 'voting', 'data-voting-enabled' => 'false', 'data-document-id' => doc.id}) do
          concat(button_to('Aye', {controller: :documents, action: :vote, vote: :aye, id: doc.id}, {remote: true, disabled: true}))
          concat(button_to('Nay', {controller: :documents, action: :vote, vote: :nay, id: doc.id}, {remote: true, disabled: true}))
          concat(button_to('Abstain', {controller: :documents, action: :vote, vote: :abstain, id: doc.id}, {remote: true, disabled: true}))
        end)
      end
    else
      concat(content_tag(:div, class: 'middle') do
        concat(content_tag(:div, {class: 'voting', 'data-voting-enabled' => 'false', 'data-document-id' => doc.id}) do
          concat(button_to('Aye', {controller: :documents, action: :vote, vote: :aye, id: doc.id}, {remote: true, disabled: true}))
          concat(button_to('Nay', {controller: :documents, action: :vote, vote: :nay, id: doc.id}, {remote: true, disabled: true}))
          concat(button_to('Abstain', {controller: :documents, action: :vote, vote: :abstain, id: doc.id}, {remote: true, disabled: true}))
        end)
      end)
    end
  end

  def _document_voting_options_m(doc)
    if request.xhr?
      content_tag(:div, class: 'middle') do
        concat(content_tag(:div, {class: 'voting', 'data-voting-enabled' => 'true', 'data-document-id' => doc.id}) do
          concat(button_to('Aye', {controller: :documents, action: :vote, vote: :aye, id: doc.id}, {remote: true}))
          concat(button_to('Nay', {controller: :documents, action: :vote, vote: :nay, id: doc.id}, {remote: true}))
          concat(button_to('Abstain', {controller: :documents, action: :vote, vote: :abstain, id: doc.id}, {remote: true}))
        end)
      end
    else
      concat(content_tag(:div, class: 'middle') do
        concat(content_tag(:div, {class: 'voting', 'data-voting-enabled' => 'true', 'data-document-id' => doc.id}) do
          concat(button_to('Aye', {controller: :documents, action: :vote, vote: :aye, id: doc.id}, {remote: true}))
          concat(button_to('Nay', {controller: :documents, action: :vote, vote: :nay, id: doc.id}, {remote: true}))
          concat(button_to('Abstain', {controller: :documents, action: :vote, vote: :abstain, id: doc.id}, {remote: true}))
        end)
      end)
    end
  end

  def _document_admin_r(doc)
    concat(content_tag(:div, class: 'middle') do
      concat(content_tag(:div, {class: 'voting'}) do
        concat(button_to('Open', {controller: :documents, action: :open_voting, id: doc.id}, {disabled: true}))
        concat(button_to('Secret', {controller: :documents, action: :open_secret, id: doc.id}, {disabled: true}))
        concat(button_to('Close', {controller: :documents, action: :close_voting, id: doc.id}, {disabled: true}))
        concat(button_to('Reset', {controller: :documents, action: :reset, id: doc.id}, {disabled: false}))
      end)
    end)
  end

  def _document_admin_osr(doc)
    concat(content_tag(:div, class: 'middle') do
      concat(content_tag(:div, {class: 'voting'}) do
        concat(button_to('Open', {controller: :documents, action: :open_voting, id: doc.id}, {disabled: false}))
        concat(button_to('Secret', {controller: :documents, action: :open_secret, id: doc.id}, {disabled: false}))
        concat(button_to('Close', {controller: :documents, action: :close_voting, id: doc.id}, {disabled: true}))
        concat(button_to('Reset', {controller: :documents, action: :reset, id: doc.id}, {disabled: false}))
      end)
    end)
  end

  def _document_admin_rc(doc)
    concat(content_tag(:div, class: 'middle') do
      concat(content_tag(:div, {class: 'voting'}) do
        concat(button_to('Open', {controller: :documents, action: :open_voting, id: doc.id}, {disabled: true}))
        concat(button_to('Secret', {controller: :documents, action: :open_secret, id: doc.id}, {disabled: true}))
        concat(button_to('Close', {controller: :documents, action: :close_voting, id: doc.id}, {disabled: false}))
        concat(button_to('Reset', {controller: :documents, action: :reset, id: doc.id}, {disabled: false}))
      end)
    end)
  end

  def document_context_menu(doc)
    content_tag :div, class: 'context-menu' do
      content_tag :ul do
        concat(content_tag :li, link_to('Edit', controller: :documents, action: :edit, id: doc.id))
        concat(content_tag :li, link_to( 'Delete', {controller: :documents, action: :destroy, id: doc.id}, method: :delete, data: {confirm: 'Are you sure you want to delete this?'}))
      end
    end
  end
end
