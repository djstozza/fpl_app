class AddMiniDraftToRounds < ActiveRecord::Migration[5.0]
  def change
    reversible do |dir|
      dir.up do
        add_column :rounds, :mini_draft, :boolean
        Round.where('deadline_time > ?', Round::SUMMER_MINI_DRAFT_DEADLINE).first.update(mini_draft: true)
        Round.where('deadline_time > ?', Round::WINTER_MINI_DRAFT_DEALINE).first.update(mini_draft: true)
      end

      dir.down do
        remove_column :rounds, :mini_draft, :boolean
      end
    end
  end
end
