class DocumentsController < ApplicationController
  def index
  end

  def new
    @doc = Document.new

    render :form
  end

  def open_voting
    doc = Document.find params[:id]

    begin
      doc.open_voting
      flash[:alert] = "Opened voting for #{doc.name}." unless request.xhr?
    rescue Exception => e
      raise e
      flash[:alert] = e.message unless request.xhr?
    end

    if request.xhr?
      render json: {result: 'success'}
    else
      redirect_to controller: :meetings, action: :show, id: doc.voting_meeting.id, anchor: 'm-documents'
    end
  end

  def reset
    doc = Document.find params[:id]

    begin
      doc.reset_votes

      ActionCable.server.broadcast 'refresh', data: 'refresh'

      flash[:alert] = "Voting reset for #{doc.name}."
    rescue Exception => e
      flash[:alert] = e.message
    end

    redirect_to controller: :meetings, action: :show, id: doc.voting_meeting.id, anchor: 'm-documents'
  end

  def close_voting
    doc = Document.find params[:id]

    doc.close_voting

    if request.xhr?
      render json: {result: 'success'}
    else
      redirect_to controller: :meetings, action: :show, id: doc.voting_meeting.id, anchor: 'm-documents'
    end
  end

  def open_secret
    # TODO: Setup Secret Voting
    doc = Document.find params[:id]

    flash[:alert] = 'This functionality is not yet implemented.'
    redirect_to controller: :meetings, action: :show, id: doc.voting_meeting.id, anchor: 'm-documents'
  end

  def create
    Document.create document_attributes

    redirect_to action: :index
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

    Document.find(params[:id]).update_attributes doc_params

    redirect_to action: :index
  end

  def destroy
    Document.find(params[:id]).destroy

    redirect_to action: :index
  end

  def vote
    doc = Document.find params[:id]

    if doc
      begin
        doc.vote @user.affiliation, params[:vote]

        if request.xhr?
          render json: {result: 'success', new_content: view_context._document_user_vote(doc), document_id: doc.id}
        else
          redirect_to controller: :meetings, action: :show, id: doc.voting_meeting.id, anchor: 'm-documents'
        end
      rescue Exception => e
        raise e
        if request.xhr?
          render json: {result: 'failure', message: e.message}
        else
          raise e
        end
      end
    else
      if request.xhr?
        render json: {result: 'failure', message: 'Couldn\'t find that document.'}
      else
        raise 'Couldn\'t find that document.'
      end
    end
  end

  private
  def document_attributes
    params.require(:document).permit(:name, :document_type_id, :link, :voting_meeting_ids, :nonvoting_meeting_ids => [])
  end
end
