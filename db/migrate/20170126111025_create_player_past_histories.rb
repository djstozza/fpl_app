class CreatePlayerPastHistories < ActiveRecord::Migration
  def change
    create_table :player_past_histories do |t|
      t.string :season_name
      t.integer :player_code
      t.integer :start_cost
      t.integer :end_cost
      t.integer :total_points
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
      t.integer :bps
      t.decimal :influence
      t.decimal :creativity
      t.decimal :threat
      t.decimal :ict_index
      t.integer :ea_index
      t.integer :season
      t.timestamps null: false
    end
  end
end
