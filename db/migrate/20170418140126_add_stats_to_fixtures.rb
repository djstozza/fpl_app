class AddStatsToFixtures < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        add_column :fixtures, :stats, :json
        Rake::Task['data_seeding:populate_fixture_stats'].invoke
      end

      dir.down do
        remove_column :fixtures, :stats, :json
      end
    end
  end
end
