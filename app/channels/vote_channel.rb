class VoteChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    # stream_from "vote:#{params[:document]}"
    stream_for Document.find(params[:document])
  end

  def vote(params)
    vote_value = params[:value].to_s
    document = Document.find params[:document]
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
