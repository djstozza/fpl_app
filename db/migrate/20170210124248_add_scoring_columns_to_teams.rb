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

    TeamsService.new.update_team_stats
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
