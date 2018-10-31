class DocumentVoteJob < ApplicationJob
  include DocumentsHelper

  queue_as :default

  def perform(*args)
    document = args[0]
    status = args[1]

    DocumentsChannel.broadcast_to document, updated_status: status
  end
end
