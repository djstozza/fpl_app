# == Schema Information
#
# Table name: teams
#
#  id                    :integer          not null, primary key
#  name                  :string
#  code                  :string
#  short_name            :string
#  strength              :integer
#  position              :integer
#  played                :integer
#  win                   :integer
#  loss                  :integer
#  draw                  :integer
#  points                :integer
#  form                  :integer
#  link_url              :integer
#  strength_overall_home :integer
#  strength_overall_away :integer
#  strength_attack_home  :integer
#  strength_attack_away  :integer
#  strength_defence_home :integer
#  strength_defence_away :integer
#  team_division         :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class Team < ActiveRecord::Base
  has_many :players

  def home_fixtures
    Fixture.where(team_h_id: id).order(round_id: :asc)
  end

  def away_fixtures
    Fixture.where(team_a_id: id).order(round_id: :asc)
  end

  def fixtures
    Fixture.where('team_a_id = :id OR team_h_id = :id', id: id)
  end

  def away_fixtures_won
    away_fixtures.where(home_vs_away_str('<'))
  end

  def away_wins
    away_fixtures_won.count
  end

  def home_fixtures_won
    home_fixtures.where(home_vs_away_str('>'))
  end

  def home_wins
    home_fixtures_won.count
  end

  def fixtures_won
    (home_fixtures_won + away_fixtures_won).sort_by(&:round_id)
  end

  def wins
    fixtures_won.count
  end

  def away_fixtures_lost
    away_fixtures.where(home_vs_away_str('>'))
  end

  def away_losses
    away_fixtures_lost.count
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

  def losses
    fixtures_lost.count
  end

  def away_fixtures_drawn
    away_fixtures.where(home_vs_away_str('='))
  end

  def away_draws
    away_fixtures_drawn.count
  end

  def home_fixtures_drawn
    home_fixtures.where(home_vs_away_str('='))
  end

  def home_draws
    home_fixtures_drawn.count
  end

  def fixtures_drawn
    (home_fixtures_drawn + away_fixtures_drawn).sort_by(&:round_id)
  end

  def draws
    fixtures_drawn.count
  end

  def away_clean_sheet_fixtures
    away_fixtures.where(team_h_score: 0)
  end

  def away_clean_sheets
    away_clean_sheet_fixtures.count
  end

  def home_clean_sheet_fixtures
    home_fixtures.where(team_a_score: 0)
  end

  def home_clean_sheets
    home_clean_sheet_fixtures.count
  end

  def clean_sheet_fixtures
    (home_clean_sheet_fixtures + away_clean_sheet_fixtures).sort_by(&:round_id)
  end

  def clean_sheets
    clean_sheet_fixtures.count
  end

  def current_form
    results_array.last(5)
  end

  def away_scoreless_fixtures
    away_fixtures.where(team_a_score: 0)
  end

  def away_scoreless_fixtures_count
    away_fixtures.count
  end

  def home_scoreless_fixtures
    home_fixtures.where(team_h_score: 0)
  end

  def home_scoreless_fixtures_count
    home_scoreless_fixtures.count
  end

  def scoreless_fixtures
    (home_scoreless_fixtures + away_scoreless_fixtures).sort_by(&:round_id)
  end

  def scorless_fixtures_count
    scorless_fixtures.count
  end

  def biggest_win_streak
    results_array.chunk { |result| result == 'W' }
                 .map { |result, results| [result, results.length] }
                 .delete_if { |group| group[0] == false }
                 .max[1]
  end

  def biggest_losing_streak
    results_array.chunk { |result| result == 'L' }
                 .map {|result, results| [result, results.length]}
                 .delete_if{|group| group[0] == false}
                 .max[1]
  end

  def undefeated_streak
    results_array.chunk { |result| result == 'W' || result == 'D' }
                 .map { |result, results| [result, results.length] }
                 .delete_if { |group| group[0] == false }
                 .max[1]
  end

  private

  def home_vs_away_str(operator)
    "team_h_score #{operator} team_a_score"
  end

  def results_array
    result_arr = []
    fixtures.where(finished: true).each do |fixture|
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



end
