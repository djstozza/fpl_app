class DraftPickChannel < ApplicationCable::Channel
  def subscribed
    stream_from "draft_picks_#{params[:room]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
