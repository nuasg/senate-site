class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def update
    Affiliation.find(user_params[:affiliation_id]).dissociate
    User.find(params[:id]).update_attributes user_params
    redirect_to action: :index
  end

  def new
    @user = User.new
  end

  def create
    User.create(user_params)

    redirect_to action: :index
  end

  def destroy
    x = User.find(params[:id])
    name = x.name
    x.destroy

    flash[:notice] = "User #{name} successfully deleted."

    redirect_to action: :index
  end

  def edit
    @user = User.find params[:id]
  end

  private
  def user_params
    params.require(:user).permit(:name, :affiliation_id, :netid, :admin)
  end
end
