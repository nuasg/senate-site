class DocumentsController < ApplicationController
  before_action :require_admin, except: [:vote]

  def index
    @documents_typed = Document.all.group_by(&:document_type)
  end

  def new
    @document = Document.new

    render :form
  end

  def open_voting
    document = Document.find params[:id]

    document.open_voting

    redirect = {controller: :meetings, action: :show, id: document.voting_meeting.id, anchor: 'm-documents'}
    show_message text: "Opened voting.", redirect: redirect
  end

  def reset
    doc = Document.find params[:id]

    doc.reset_votes

    redirect = {controller: :meetings, action: :show, id: doc.voting_meeting.id, anchor: 'm-documents'}
    show_message text: "Voting reset.", redirect: redirect
  end

  def close_voting
    doc = Document.find params[:id]

    doc.close_voting

    redirect = {controller: :meetings, action: :show, id: doc.voting_meeting.id, anchor: 'm-documents'}
    show_message text: "Voting closed.", redirect: redirect
  end

  def open_secret
    # TODO: Setup Secret Voting
    show_message text: 'This functionality is not yet implemented.', result: 'failure'
  end

  def create
    document = Document.new document_attributes

    message = 'Failed to create document.'
    message = 'Document created.' if document.save

    show_message text: message, redirect: {action: :index}
  end

  def edit
    @document = Document.find params[:id]

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
    message = 'Failed to destroy document.'
    message = 'Document destroyed.' if Document.destroy params[:id]

    show_message text: message, redirect: {action: :index}
  end

  def vote
    document = Document.find params[:id]

    raise "Couldn't find that document." if document.nil?

    document.vote @user, params[:vote]

    if request.xhr?
      render json: {result: 'success',
                    new_content: render_to_string('shared/_document_vote_controls', locals: {document: document}, layout: false)}
    else
      redirect_to controller: :meetings, action: :show, id: doc.voting_meeting.id, anchor: 'm-documents'
    end
  end

  private
  def document_attributes
    params.require(:document).permit(:name,
                                     :document_type_id,
                                     :link,
                                     :voting_meeting_ids,
                                     :nonvoting_meeting_ids => [])
  end
end
