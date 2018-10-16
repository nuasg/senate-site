module ApplicationHelper
  def is_admin?
    User.admin? session[:user_id]
  end

  def edit_icon
    content_tag('span', nil, class: 'fas fa-edit')
  end

  def delete_icon
    content_tag('span', nil, class: 'fas fa-trash')
  end

  def context_menu
    content_tag 'span', nil, class: 'fas fa-ellipsis-v', data: {toggle: 'menu'}
  end
end
