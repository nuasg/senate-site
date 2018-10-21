class VotingChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'voting'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
