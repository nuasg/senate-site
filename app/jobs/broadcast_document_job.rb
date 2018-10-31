class BroadcastDocumentJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    document = args[0]

    DocumentsChannel.broadcast_to document, voting_open: document.voting_open
  end
end
