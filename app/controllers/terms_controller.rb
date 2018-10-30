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
    term = Term.find params[:id]

    message = 'Failed to update term.'
    message = 'Updated term.' if term.update_attributes term_attributes

    show_message text: message, redirect: {action: :index}
  end

  def create
    term = Term.new term_attributes

    message = 'Failed to create term.'
    message = 'Created term.' if term.save

    show_message text: message, redirect: {action: :index}
  end

  def destroy
    message = 'Failed to delete term.'
    message = 'Deleted term.' if Term.destroy params[:id]

    show_message text: message, redirect: {action: :index}
  end

  private
  def term_attributes
    params.require('term').permit(:name, :begin, :end)
  end
end
