module AffiliationHelper
  def affiliation_type_select(form_affiliation)
    form_affiliation.select :affiliation_type_id,
                            options_from_collection_for_select(AffiliationType.all,
                                                               'id',
                                                               'name',
                                                               @affiliation.type&.id)
  end

  def affiliation_user_select
    select_tag :user_id,
               options_from_collection_for_select(User.all,
                                                  'id',
                                                  'name', @affiliation.user&.id),
               {include_blank: true}
  end

  def affiliation_user(affiliation)
    affiliation.user.nil? ? content_tag(:span, 'None', class: 'text-muted') : affiliation.user.name
  end

  def affiliation_edit_link(affiliation)
    link_to edit_icon, action: :edit, id: affiliation.id
  end

  def affiliation_delete_link(affiliation)
    link_to delete_icon,
            {action: :destroy, id: affiliation.id},
            method: :delete,
            data: {confirm: 'Are you sure you want to delete this?'}
  end
end
