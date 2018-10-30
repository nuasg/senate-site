module DocumentsHelper
  #@param [Document] document
  #@param [User] user
  def aye_button(document:, user:)
    voting_button vote_type: :aye,
                  document: document,
                  can_vote: user.can_vote_now?(document),
                  user_vote: document.user_vote(user)
  end

  #@param [Document] document
  #@param [User] user
  def nay_button(document:, user:)
    voting_button vote_type: :nay,
                  document: document,
                  can_vote: user.can_vote_now?(document),
                  user_vote: document.user_vote(user)
  end

  #@param [Document] document
  #@param [User] user
  def abstain_button(document:, user:)
    voting_button vote_type: :abstain,
                  document: document,
                  can_vote: user.can_vote_now?(document),
                  user_vote: document.user_vote(user)
  end

  #@param [Document] document
  def document_edit_link(document)
    link_to 'Edit', controller: :documents, action: :edit, id: document.id
  end

  #@param [Document] document
  def document_delete_link(document)
    link_to 'Delete',
            {controller: :documents, action: :destroy, id: document.id},
            method: :delete,
            data: {confirm: 'Are you sure you want to delete this?'}
  end

  #@param [Document] document
  def open_button(document:)
    admin_button name: 'Open',
                 action: :open_voting,
                 document: document,
                 disabled: document.voting_open || !document.voting_meeting&.open?
  end

  #@param [Document] document
  def close_button(document:)
    admin_button name: 'Close',
                 action: :close_voting,
                 document: document,
                 disabled: !document.voting_open
  end

  #@param [Document] document
  def secret_button(document:)
    admin_button name: 'Secret',
                 action: :open_secret,
                 document: document,
                 disabled: document.voting_open || !document.voting_meeting&.open?
  end

  #@param [Document] document
  def reset_button(document:)
    admin_button name: 'Reset',
                 action: :reset,
                 document: document,
                 disabled: false
  end

  def document_type_select(form_document)
    form_document.select :document_type_id,
                         options_from_collection_for_select(DocumentType.all,
                                                            'id',
                                                            'name',
                                                            form_document.object.type&.id)
  end

  def document_nonvoting_select(form_document)
    form_document.select :nonvoting_meeting_ids,
                         options_from_collection_for_select(Meeting.all.order(date: :desc),
                                                            'id',
                                                            'real_name',
                                                            form_document.object&.nonvoting_meeting_ids),
                         {},
                         {multiple: true}
  end

  def document_voting_select(form_document)
    form_document.select :voting_meeting_ids,
                         options_from_collection_for_select(Meeting.all.order(date: :desc),
                                                            'id',
                                                            'real_name',
                                                             form_document.object&.voting_meeting_ids),
                         {include_blank: true}
  end

  private
  #@param [Symbol] vote_type
  #@param [Document] document
  #@param [Symbol] user_vote
  def voting_button(vote_type:, document:, can_vote:, user_vote:)
    is_user_vote = user_vote == vote_type ? 'user_vote' : ''

    button_to vote_type.to_s,
              {controller: :documents, action: :vote, vote: :aye, id: document.id},
              {remote: true, disabled: !can_vote, class: is_user_vote}
  end

  #@param [String] name
  #@param [Symbol] action
  #
  def admin_button(name:, action:, document:, disabled:)
    button_to name,
              {controller: :documents, action: action, id: document.id},
              {disabled: disabled}
  end
end
