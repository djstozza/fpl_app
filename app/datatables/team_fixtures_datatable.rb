class TeamFixturesDatatable < Datatable
  def initialize(view_context, team)
    super(view_context)
    @team = team
    @records = @team.fixtures.order(sorting).to_a.delete_if { |fixture| fixture.round_id == nil }
    @records_total = @team.fixtures.count
    @records_filtered = @records.count
    @process_record_lambda = -> (fixture) do
      [
        fixture.round_id,
        Time.parse(fixture.kickoff_time).strftime('%d/%m/%y %H:%M'),
        opponent_link(fixture),
        (fixture.team_h_id == @team.id ? 'H' : 'A'),
        win_loss_or_draw(fixture),
        ("#{fixture.team_h_score} - #{fixture.team_a_score}" if fixture.finished),
        opponent_difficulty(fixture),
        fixture_advantage(fixture)
      ]
    end
  end

  def per_page
    @records_total
  end

  private

  def columns
    %w(round_id
       kickoff_time
       opponent
       home_or_away
       result
       score
       fixture_difficulty
       favour_home_or_away)
  end

  def home_fixture(fixture)
    @team.home_fixtures.include?(fixture)
  end

  def fixture_advantage(fixture)
    advantage = if home_fixture(fixture)
                fixture.team_a_difficulty - fixture.team_h_difficulty
               else
                 fixture.team_h_difficulty - fixture.team_a_difficulty
               end
    advantage_type = if advantage < 0
                       'o'
                     elsif advantage == 0
                       'e'
                     else
                       't'
                     end
    content_tag(:div, nil,
                class: "js-team-advantage difficulty-#{advantage_type}#{advantage.abs unless advantage == 0}")
  end

  def opponent_difficulty(fixture)
    difficulty = if home_fixture(fixture)
                   fixture.team_h_difficulty
                 else
                   fixture.team_a_difficulty
                 end
    content_tag(:div, nil,
                class: "js-opponent-difficulty difficulty-o#{difficulty}")
  end

  def opponent_link(fixture)
    opponent = if home_fixture(fixture)
                 Team.find_by(id: fixture.team_a_id)
               else
                 Team.find_by(id: fixture.team_h_id)
               end
    link_to(opponent.short_name, team_path(opponent))
  end

  def win_loss_or_draw(fixture)
    if @team.fixtures_won.include?(fixture)
      'W'
    elsif @team.fixtures_lost.include?(fixture)
      'L'
    elsif @team.fixtures_drawn.include?(fixture)
      'D'
    end
  end
end
