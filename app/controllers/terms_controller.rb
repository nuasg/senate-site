class TermsController < ApplicationController
  before_action :require_admin

  def index
    @terms = Term.all.order begin: :desc
  end

  def new
    @term = Term.new

    render :form
  end

  def edit
    @term = Term.find(params[:id])

    render :form
  end

  def update
    if Term.find(params[:id]).update_attributes term_attributes
      flash[:alert] = "Updated term \"#{term_attributes[:name]}\"."
    else
      flash[:alert] = 'Failed to update term.'
    end

    redirect_to action: :index
  end

  def create
    term = Term.create term_attributes

    if term.save
      flash[:alert] = "Created term \"#{term_attributes[:name]}\"."
    else
      flash[:alert] = 'Failed to create term.'
    end

    redirect_to action: :index
  end

  def destroy
    term = Term.find(params[:id])
    name = term.name

    term.destroy

    flash[:alert] = "Deleted term \"#{name}\"."

    redirect_to action: :index
  end

  private
  def term_attributes
    params.require('term').permit(:name, :begin, :end)
  end
end
