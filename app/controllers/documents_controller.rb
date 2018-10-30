class DocumentsController < ApplicationController
  before_action :require_admin, except: [:vote]

  def index
    @documents_typed = Document.all.group_by(&:document_type)
  end

  def new
    @doc = Document.new

    render :form
  end

  def open_voting
    doc = Document.find params[:id]

    doc.open_voting

    redirect = {controller: :meetings, action: :show, id: doc.voting_meeting.id, anchor: 'm-documents'}
    show_message text: "Opened voting for #{doc.name}.", redirect: redirect
  end

  def reset
    doc = Document.find params[:id]

    doc.reset_votes

    redirect = {controller: :meetings, action: :show, id: doc.voting_meeting.id, anchor: 'm-documents'}

    show_message text: "Voting reset for #{doc.name}.", redirect: redirect
  end

  def close_voting
    doc = Document.find params[:id]

    doc.close_voting

    redirect = {controller: :meetings, action: :show, id: doc.voting_meeting.id, anchor: 'm-documents'}

    show_message text: "Voting closed for #{doc.name}.", redirect: redirect
  end

  def open_secret
    # TODO: Setup Secret Voting
    show_message text: 'This functionality is not yet implemented.', result: 'failure'
  end

  def create
    Document.create document_attributes

    show_message text: 'Document created.', redirect: {action: :index}
  end

  def edit
    @doc = Document.find params[:id]

    render :form
  end

  def update
    doc_params = document_attributes

    if doc_params[:voting_meeting_ids]
      doc_params[:voting_meeting_ids] = ["", doc_params[:voting_meeting_ids]]
    end

    message = "Failed to update document."
    message = "Updated document." if Document.find(params[:id]).update_attributes doc_params

    show_message text: message, redirect: {action: :index}
  end

  def destroy
    Document.destroy params[:id]

    show_message text: 'Document deleted.', redirect: {action: :index}
  end

  def vote
    document = Document.find params[:id]

    raise "Couldn't find that document." if document.nil?

    document.vote @user.affiliation, params[:vote]

    if request.xhr?
      render json:
                 {result: 'success',
                  new_content: render(partial: 'shared/document_vote_controls', locals: {document: document}),
                  document_id: document.id}
    else
      redirect_to controller: :meetings, action: :show, id: doc.voting_meeting.id, anchor: 'm-documents'
    end
  end

  private
  def document_attributes
    params.require(:document).permit(:name, :document_type_id, :link, :voting_meeting_ids, :nonvoting_meeting_ids => [])
  end
end
