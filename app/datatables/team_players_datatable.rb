class TeamPlayersDatatable < Datatable
  def initialize(view_context, team, position)
    super(view_context)
    @records = position.players.where(team_id: team.id).order(sorting)
    @records_total = position.players.where(team_id: team.id).count
    @records_filtered = @records.count

    @process_record_lambda = -> (player) do
      [
        player.last_name,
        player.minutes,
        player.goals_scored,
        player.assists,
        player.own_goals,
        player.yellow_cards,
        player.red_cards,
        player.penalties_saved,
        player.penalties_missed,
        player.clean_sheets,
        player.saves,
        player.bonus,
        player.dreamteam_count,
        player.points_per_game,
        player.total_points
      ]
    end
  end

  def per_page
    @records_total
  end


  private

  def columns
    %w(last_name
       minutes
       goals_scored
       assists
       own_goals
       yellow_cards
       red_cards
       penalties_saved
       penalties_missed
       clean_sheets
       saves
       bonus
       dreamteam_count
       points_per_game
       total_points)
  end
end
