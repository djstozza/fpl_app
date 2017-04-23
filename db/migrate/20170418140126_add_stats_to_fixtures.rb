class AddStatsToFixtures < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        add_column :fixtures, :stats, :json
        FixturesService.new.update_fixtures
      end

      dir.down do
        remove_column :fixtures, :stats, :json
      end
    end
  end
end
