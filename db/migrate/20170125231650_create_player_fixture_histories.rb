class CreatePlayerFixtureHistories < ActiveRecord::Migration
  def change
    create_table :player_fixture_histories do |t|
      t.string :kickoff_time
      t.integer :team_h_score
      t.integer :team_a_score
      t.boolean :was_home
      t.integer :round_id
      t.integer :total_points
      t.integer :value
      t.integer :minutes
      t.integer :goals_scored
      t.integer :assists
      t.integer :clean_sheets
      t.integer :goals_conceded
      t.integer :own_goals
      t.integer :penalties_saved
      t.integer :penalties_missed
      t.integer :yellow_cards
      t.integer :red_cards
      t.integer :saves
      t.integer :bonus
      t.integer :influence
      t.decimal :creativity
      t.decimal :threat
      t.decimal :ict_index
      t.decimal :ea_index
      t.integer :open_play_crosses
      t.integer :big_chances_created
      t.integer :clearances_blocks_interceptions
      t.integer :recoveries
      t.integer :key_passes
      t.integer :tackles
      t.integer :winning_goals
      t.integer :attempted_passes
      t.integer :penalties_conceded
      t.integer :big_chances_missed
      t.integer :errors_leading_to_goal
      t.integer :errors_leading_to_goal_attempt
      t.integer :tackled
      t.integer :offside
      t.integer :target_missed
      t.integer :fouls
      t.integer :dribbles
      t.integer :player_id
      t.integer :fixture_id
      t.integer :opponent_team_id
      t.timestamps null: false
    end
  end
end
