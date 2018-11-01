class AffiliationsController < ApplicationController
  before_action :require_admin

  def index
    @affiliations = Affiliation.all.order :affiliation_type_id, :name
  end

  def new
    @affiliation = Affiliation.new
    render :form
  end

  def create
    affiliation = Affiliation.new affiliation_attributes

    message = 'Failed to create affiliation.'
    message = "Created affiliation." if affiliation.save

    show_message text: message, redirect: {action: :index}
  end

  def edit
    @affiliation = Affiliation.find params[:id]

    render :form
  end

  def update
    affiliation = Affiliation.find params[:id]

    message = 'Failed to update affiliation.'
    message = "Affiliation updated successfully." if affiliation.update_attributes affiliation_attributes

    show_message text: message, redirect: {action: :index}
  end

  def destroy
    message = "Failed to delete affiliation."
    message = "Affiliation deleted." if Affiliation.destroy params[:id]

    show_message text: message, redirect: {action: :index}
  end

  private
  def affiliation_attributes
    # Allow to set what student represents this affiliation through a form
    if params[:user_id] && !params[:user_id].nil? && params[:user_id] != ""
      p = params.require('affiliation').permit :enabled, :name, :affiliation_type_id, :user
      p[:user] = User.find params[:user_id]
      return p
    end

    params.require('affiliation').permit :enabled, :name, :affiliation_type_id, :user
  end
end
