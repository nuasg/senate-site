class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def update
    User.find(params[:id]).update_attributes user_attributes

    redirect_to action: :index
  end

  def new
    @user_form = User.new

    render :form
  end

  def create
    user = User.new user_attributes

    if user.save
      flash[:alert] = "Created user \"#{user_attributes[:name]}\"."
    else
      flash[:alert] = 'Failed to create user.'
    end

    redirect_to action: :index
  end

  def destroy
    x = User.find(params[:id])
    name = x.name

    if x.id == session[:user_id]
      flash[:alert] = "You cannot delete yourself."

      redirect_to action: :index and return
    end

    x.destroy

    flash[:alert] = "Deleted user \"#{name}\"."

    redirect_to action: :index
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
