class CreateWaiverPicks < ActiveRecord::Migration[5.0]
  def change
    create_table :waiver_picks do |t|
      t.integer :pick_number
      t.integer :status, default: 0
      t.references :list_position, index: true
      t.references :player, index: true
      t.references :round, index: true
      t.references :fpl_team, index: true
      t.references :league, index: true
      t.timestamps null: false
    end
  end
end
