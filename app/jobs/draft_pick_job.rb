class DraftPickJob < ApplicationJob
  queue_as :default

  def perform(league_id:, draft_pick_id:)
    league = League.find_by(id: league_id)
    ActionCable.server.broadcast(
      "draft_picks_league #{league_id}",
      draft_picks: league.draft_picks,
      current_draft_pick: DraftPick.find_by(id: draft_pick_id)
    )
  end
end
