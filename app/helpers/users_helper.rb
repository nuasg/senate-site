module UsersHelper
  def user_affiliation(user)
    user.affiliation.nil? ?
        content_tag('span', 'None', class: 'text-muted') :
        user.affiliation.name
  end

  def user_email(user)
    link_to user.email, "mailto:#{user.email}" unless user.email.nil?
  end

  def user_admin(user)
    user.admin ? 'Yes' : 'No'
  end

  def user_delete_link(user)
    link_to delete_icon, {controller: :users, action: :destroy, id: user.id}, method: :delete,
        data: {confirm: 'Are you sure you want to delete this?'} unless user.id == @user.id
  end
end
