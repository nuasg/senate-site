module ApplicationHelper
  def is_admin?
    session[:user_id] && User.find(session[:user_id]).admin
  end

  def edit_icon
    content_tag('span', nil, class: 'fas fa-edit')
  end

  def delete_icon
    content_tag('span', nil, class: 'fas fa-trash')
  end

  def context_menu(type)
    content_tag 'span', nil, class: 'fas fa-ellipsis-v', data: {toggle: 'menu', type: type}
  end
end
