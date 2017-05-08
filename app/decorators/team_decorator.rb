class TeamDecorator < SimpleDelegator
  include ::ActionView::Helpers::TagHelper

  def fixtures
    home_fixtures.or(away_fixtures).order(:round_id)
  end

  def goals(team_status_1, team_status_2)
    goals = 0
    home_fixtures.finished.each do |fixture|
      goals += fixture.public_send("#{team_status_1}_score")
    end
    away_fixtures.finished.each do |fixture|
      goals += fixture.public_send("#{team_status_2}_score")
    end
    goals
  end

  def away_fixtures_won
    away_fixtures.finished.where(home_vs_away_str('<'))
  end

  def away_wins
    away_fixtures_won.count
  end

  def home_fixtures_won
    home_fixtures.finished.where(home_vs_away_str('>'))
  end

  def home_wins
    home_fixtures_won.count
  end

  def fixtures_won
    (home_fixtures_won + away_fixtures_won).sort_by(&:round_id)
  end

  def away_fixtures_lost
    away_fixtures.finished.where(home_vs_away_str('>'))
  end

  def away_losses
    away_fixtures_lost.finished.count
  end

  def home_fixtures_lost
    home_fixtures.where(home_vs_away_str('<'))
  end

  def home_losses
    home_fixtures_lost.count
  end

  def fixtures_lost
    (home_fixtures_lost + away_fixtures_lost).sort_by(&:round_id)
  end

  def away_fixtures_drawn
    away_fixtures.finished.where(home_vs_away_str('='))
  end

  def away_draws
    away_fixtures_drawn.count
  end

  def home_fixtures_drawn
    home_fixtures.finished.where(home_vs_away_str('='))
  end

  def home_draws
    home_fixtures_drawn.count
  end

  def fixtures_drawn
    (home_fixtures_drawn + away_fixtures_drawn).sort_by(&:round_id)
  end

  def away_clean_sheet_fixtures
    away_fixtures.finished.where(team_h_score: 0)
  end

  def away_clean_sheets
    away_clean_sheet_fixtures.count
  end

  def home_clean_sheet_fixtures
    home_fixtures.where(team_a_score: 0)
  end

  def home_clean_sheets
    home_clean_sheet_fixtures.finished.count
  end

  def clean_sheet_fixtures
    (home_clean_sheet_fixtures + away_clean_sheet_fixtures).sort_by(&:round_id)
  end

  def clean_sheets
    clean_sheet_fixtures.count
  end

  def current_form
    results_array.last(5).join
  end

  def biggest_win_streak
    results_array.chunk { |result| result == 'W' }
                 .map { |result, results| [result, results.length] }
                 .delete_if { |group| group[0] == false }
                 .max[1]
  end

  def biggest_losing_streak
    results_array.chunk { |result| result == 'L' }
                 .map { |result, results| [result, results.length] }
                 .delete_if { |group| group[0] == false }
                 .max[1]
  end

  def undefeated_streak
    results_array.chunk { |result| result == 'W' || result == 'D' }
                 .map { |result, results| [result, results.length] }
                 .delete_if { |group| group[0] == false }
                 .max[1]
  end

  def find_position
    ladder.index(__getobj__) + 1
  end

  def goal_calculator(team_status_1, team_status_2)
    goals = 0
    home_fixtures.finished.each do |fixture|
      goals += fixture.public_send("#{team_status_1}_score")
    end
    away_fixtures.finished.each do |fixture|
      goals += fixture.public_send("#{team_status_2}_score")
    end
    goals
  end

  def fixture_hash
    arr = []
    fixtures.each do |fixture|
      home_fixture = home_fixtures.include?(fixture)
      opponent = home_fixture ? fixture.away_team : fixture.home_team
      advantage = advantage(fixture, home_fixture)
      arr << {
        round_id: fixture.round_id,
        kickoff_time: fixture.kickoff_time.strftime('%d/%m/%y %H:%M'),
        opponent_id: opponent.id,
        opponent_short_name: opponent.short_name,
        leg: home_fixture ? 'H' : 'A',
        result: win_loss_or_draw(fixture),
        score: "#{fixture.team_h_score} - #{fixture.team_a_score}",
        advantage: advantage,
        fixture_advantage: fixture_advantage(advantage)
      }
    end
    arr
  end


  private

  def home_vs_away_str(operator)
    "team_h_score #{operator} team_a_score"
  end

  def results_array
    result_arr = []
    fixtures.finished.order(:round_id).each do |fixture|
      if fixtures_won.include?(fixture)
        result_arr << 'W'
      elsif fixtures_lost.include?(fixture)
        result_arr << 'L'
      elsif fixtures_drawn.include?(fixture)
        result_arr << 'D'
      end
    end
    result_arr
  end

  def win_loss_or_draw(fixture)
    if fixtures_won.include?(fixture)
      'W'
    elsif fixtures_lost.include?(fixture)
      'L'
    elsif fixtures_drawn.include?(fixture)
      'D'
    else
      '-'
    end
  end

  def advantage(fixture, home_fixture)
    if home_fixture
      fixture.team_a_difficulty - fixture.team_h_difficulty
     else
       fixture.team_h_difficulty - fixture.team_a_difficulty
     end
  end

  def fixture_advantage(advantage)
    advantage_type = if advantage < 0
                       'o'
                     elsif advantage == 0
                       'e'
                     else
                       't'
                     end
    "difficulty-#{advantage_type}#{advantage.abs unless advantage == 0}"
  end

  def ladder
    Team.all.sort do |a, b|
      [b.points, b.goal_difference] <=> [a.points, a.goal_difference]
    end
  end
end
