class DocumentsChannel < ApplicationCable::Channel
  def subscribed
    document = Document.find params[:id]
    stream_for document
  end
end
