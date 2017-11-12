require 'rails_helper'

RSpec.describe Leagues::CreateDraftForm, type: :form do
  let(:league) { FactoryBot.create(:league, commissioner: FactoryBot.create(:user)) }

  before do
    FactoryBot.create(:fpl_team, league: league, user: league.commissioner)
    9.times do
      FactoryBot.create(:fpl_team, league: league, user: FactoryBot.create(:user))
    end
  end

  it 'successfully creates draft picks for the league' do
    form = Leagues::CreateDraftForm.new(league: league, current_user: league.commissioner)
    form.save
    expect(form.league.draft_picks.count).to eq(15 * form.league.fpl_teams.count)
    expect(form.league.draft_picks.first.fpl_team.draft_picks.map { |p| p.pick_number })
      .to eq([1, 20, 21, 40, 41, 60, 61, 80, 81, 100, 101, 120, 121, 140, 141])
    expect(form.league.draft_picks.last.fpl_team.draft_picks.map { |p| p.pick_number })
      .to eq([10, 11, 30, 31, 50, 51, 70, 71, 90, 91, 110, 111, 130, 131, 150])
  end

  it 'can only be initiated by the league commissioner' do
    form = Leagues::CreateDraftForm.new(league: league, current_user: league.fpl_teams.last.user)
    expect{ form.save }.to_not change(DraftPick, :count)
    expect(form.errors.full_messages).to include('You are not authorised to initiate the draft')
  end
end
