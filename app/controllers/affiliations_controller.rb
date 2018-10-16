class AffiliationsController < ApplicationController
  def index
    @affiliations = Affiliation.all
  end

  def new
    @affiliation = Affiliation.new

    render :form
  end

  def create
    affiliation = Affiliation.create affiliation_attributes

    if affiliation.save
      flash[:alert] = "Created affiliation \"#{affiliation.name}\"."
    else
      flash[:alert] = 'Failed to create affiliation.'
    end

    redirect_to action: :index
  end

  def edit
    @affiliation = Affiliation.find params[:id]

    render :form
  end

  def update
    affiliation = Affiliation.find params[:id]

    if affiliation.update_attributes affiliation_attributes
      flash[:alert] = "Affiliation \"#{affiliation.name}\" updated successfully."
    else
      flash[:alert] = 'Failed to update affiliation.'
    end

    redirect_to action: :index
  end

  def destroy
    affiliation = Affiliation.find(params[:id])
    name = affiliation.name
    affiliation.destroy

    flash[:alert] = "Affiliation \"#{name}\" deleted."

    redirect_to action: :index
  end

  private
  def affiliation_attributes
    if params[:user_id] && !params[:user_id].nil? && params[:user_id] != ""
      p = params.require('affiliation').permit :enabled, :name, :affiliation_type_id, :user
      p[:user] = User.find params[:user_id]
      return p
    end

    params.require('affiliation').permit :enabled, :name, :affiliation_type_id, :user
  end
end
