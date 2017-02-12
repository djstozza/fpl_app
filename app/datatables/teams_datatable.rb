class TeamsDatatable < Datatable
  def initialize(view_context)
    super(view_context)
    @records = Team.all.order(sorting)
    @records_total = Team.count
    @records_filtered = @records.count

    team_ids = paginated_records.map(&:id)

    @process_record_lambda = -> (team) do
      [
        team.position,
        team.short_name,
        team.fixtures.where(finished: true).count,
        team.wins,
        team.losses,
        team.draws,
        team.current_form,
        team.clean_sheets,
        team.goals_for,
        team.goals_against,
        team.goal_difference,
        team.points
      ]
    end
  end

  private



  def columns
    %w(position
       short_name
       matches
       wins
       losses
       draws
       form
       clean_sheets
       goals_for
       goals_against
       goal_difference
       points)
  end
end
