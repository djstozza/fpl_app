class TeamDecorator < SimpleDelegator

  def fixtures
    Fixture.where('team_a_id = :id OR team_h_id = :id', id: id)
  end

  def home_fixtures
    Fixture.where(team_h_id: id).order(round_id: :asc)
  end

  def away_fixtures
    Fixture.where(team_a_id: id).order(round_id: :asc)
  end

  def goals(team_status_1, team_status_2)
    goals = 0
    home_fixtures.where(finished: true).each do |fixture|
      goals += fixture.public_send("#{team_status_1}_score")
    end
    away_fixtures.where(finished: true).each do |fixture|
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

  def position
    ladder.index(__getobj__) + 1
  end


  private

  def home_vs_away_str(operator)
    "team_h_score #{operator} team_a_score"
  end

  def results_array
    result_arr = []
    fixtures.where(finished: true).order(:round_id).each do |fixture|
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

  def ladder
    Team.all.sort { |a, b| [b.points, b.goal_difference] <=> [a.points, a.goal_difference] }
  end
end
