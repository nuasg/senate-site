class UsersController < ApplicationController
  before_action :require_admin

  def index
    @users = User.all
  end

  def update
    user = User.find params[:id]

    message = 'Failed to update user.'
    message = 'Updated user.' if user.update_attributes user_attributes

    show_message text: message, redirect: {action: :index}
  end

  def new
    @user_form = User.new

    render :form
  end

  def create
    user = User.new user_attributes

    message = 'Failed to create user.'
    message = 'Created user.' if user.save

    show_message text: message, redirect: {action: :index}
  end

  def destroy
    message = 'Failed to delete user.'
    message = 'Deleted user.' if User.destroy params[:id]

    show_message text: message, redirect: {action: :index}
  end

  def edit
    @user_form = User.find params[:id]

    render :form
  end

  private
  def user_attributes
    params.require(:user).permit(:name, :affiliation_id, :netid, :admin, :email)
  end
end
