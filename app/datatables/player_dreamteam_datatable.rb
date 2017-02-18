class PlayerDreamteamDatatable < Datatable
  def initialize(view_context)
    super(view_context)

    @records = Player.where(in_dreamteam: true).order(sorting)
    @records_total = Player.where(in_dreamteam: true).count
    @records_filtered = @records.count
    @process_record_lambda = -> (player) do
      [
        player.last_name,
        player.team.short_name,
        player.position.singular_name_short,
        player.influence,
        player.threat,
        player.creativity,
        player.bonus,
        player.form,
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
       team_id
       position_id
       influence
       creativity
       influence
       threat
       bonus
       form
       dreamteam_count
       points_per_game
       total_points)
  end
end
