class AffiliationsController < ApplicationController
  def index
    @affiliations = Affiliation.all
  end

  def new
    @affiliation = Affiliation.new
  end

  def create
    Affiliation.create(affiliation_params)

    redirect_to action: :index
  end

  def edit
    @affiliation = Affiliation.find params[:id]
  end

  def update
    @affiliation = Affiliation.find params[:id]
    @affiliation.update_attributes! affiliation_params

    if params[:user].empty?
      @affiliation.dissociate
    else
      nuser = User.find params[:user]

      if @affiliation.user && @affiliation.user != nuser
        @affiliation.dissociate
      end

      @affiliation.user = nuser
    end

    redirect_to action: :index
  end

  def destroy
    affiliation = Affiliation.find(params[:id])
    name = affiliation.name
    affiliation.destroy

    flash[:notice] = "Affiliation \"#{name}\" successfully deleted."

    redirect_to action: :index
  end

  private
  def affiliation_params
    params.require('affiliation').permit(:enabled, :name, :affiliation_type_id)
  end
end
