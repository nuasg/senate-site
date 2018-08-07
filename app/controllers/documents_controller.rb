class DocumentsController < ApplicationController
  def index
  end

  def new
    @doc = Document.new
  end

  def create
    Document.create document_params

    redirect_to action: :index
  end

  def edit
    @doc = Document.find params[:id]
  end

  def update
    Document.find(params[:id]).update_attributes document_params

    redirect_to action: :index
  end

  def destroy
    Document.find(params[:id]).destroy

    redirect_to action: :index
  end

  private
  def document_params
    params.require(:document).permit(:name, :document_type_id, :link, :meeting_ids => [])
  end
end
