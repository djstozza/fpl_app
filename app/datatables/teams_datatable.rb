class TeamsDatatable < Datatable
  def initialize(view_context)
    super(view_context)
    @records = Team.all.order(sorting)
    @records_total = Team.count
    @records_filtered = @records.count

    @process_record_lambda = -> (team) do
      team_decorator = TeamDecorator.new(team)
      [
        team_decorator.position,
        link_to(team_decorator.short_name, team),
        team_decorator.fixtures.where(finished: true).count,
        team_decorator.wins,
        team_decorator.losses,
        team_decorator.draws,
        team_decorator.current_form,
        team_decorator.clean_sheets,
        team_decorator.goals_for,
        team_decorator.goals_against,
        team_decorator.goal_difference,
        team_decorator.points
      ]
    end
  end

  def per_page
    @records_total
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
