class AddScoringColumnsToTeams < ActiveRecord::Migration
  def up
    add_column :teams, :goals_for, :integer
    add_column :teams, :goals_against, :integer
    add_column :teams, :goal_difference, :integer
    add_column :teams, :clean_sheets, :integer
    add_column :teams, :wins, :integer
    add_column :teams, :losses, :integer
    add_column :teams, :draws, :integer
    remove_column :teams, :draw, :integer
    remove_column :teams, :loss, :integer
    remove_column :teams, :win, :integer
    remove_column :teams, :form, :decimal
    add_column :teams, :form, :string

    Team.all.each do |team|
      team_decorator = TeamDecorator.new(team)
      team.update(wins: team_decorator.fixtures_won.count,
                  losses: team_decorator.fixtures_lost.count,
                  draws: team_decorator.fixtures_drawn.count,
                  clean_sheets: team_decorator.clean_sheet_fixtures.count,
                  goals_for: team_decorator.goal_calculator('team_h', 'team_a'),
                  goals_against: team_decorator.goal_calculator('team_a', 'team_h'),
                  goal_difference: (team_decorator.goals_for - team_decorator.goals_against),
                  points: (team_decorator.fixtures_won.count * 3 + team_decorator.fixtures_drawn.count),
                  played: team_decorator.fixtures.where(finished: true).count,
                  form: team_decorator.current_form)
    end

    Team.all.each do |team|
      team.update(position: (Team.ladder.index(team) + 1))
    end
  end

  def down
    remove_column :teams, :goals_for, :integer
    remove_column :teams, :goals_against, :integer
    remove_column :teams, :goal_difference, :integer
    remove_column :teams, :clean_sheets, :integer
    remove_column :teams, :wins, :integer
    remove_column :teams, :losses, :integer
    remove_column :teams, :draws, :integer
    add_column :teams, :draw, :integer
    add_column :teams, :loss, :integer
    add_column :teams, :win, :integer
    remove_column :teams, :form, :string
    add_column :teams, :form, :decimal
  end
end
