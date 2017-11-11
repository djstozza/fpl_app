class MiniDraftPickChannel < ApplicationCable::Channel
  def subscribed
    stream_from "mini_draft_picks_#{params[:room]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
