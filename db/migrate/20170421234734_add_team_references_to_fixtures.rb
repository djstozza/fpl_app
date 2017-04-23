class AddTeamReferencesToFixtures < ActiveRecord::Migration[5.0]
  def change
    reversible do |dir|
      dir.up do
        remove_column :fixtures, :team_h_id, :integer
        remove_column :fixtures, :team_a_id, :integer
        add_reference :fixtures, :team_h, index: true, foreign_key: { to_table: :teams }
        add_reference :fixtures, :team_a, index: true, foreign_key: { to_table: :teams }
      end

      dir.down do |dir|
        remove_reference :fixtures, :team_h, index: true
        remove_reference :fixtures, :team_a, index: true
        add_column :fixtures, :team_h_id, :integer
        add_column :fixtures, :team_a_id, :integer
      end
    end

    FixturesService.new.update_fixtures
  end
end
