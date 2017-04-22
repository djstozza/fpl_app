class DropPlayerPastHistories < ActiveRecord::Migration[5.0]
  def change
    drop_table(:player_past_histories) if table_exists?(:player_past_histories)
  end
end
