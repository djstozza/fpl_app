class DropPlayerFixtureHistories < ActiveRecord::Migration[5.0]
  def change
    drop_table(:player_fixture_histories) if table_exists?(:player_fixture_histories)
  end
end
