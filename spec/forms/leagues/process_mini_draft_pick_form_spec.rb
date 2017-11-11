require 'rails_helper'

RSpec.describe Leagues::ProcessMiniDraftPickForm, type: :form do
  let(:user) { FactoryGirl.create(:user) }
  let(:league) { FactoryGirl.create(:league, commissioner: user) }
  let(:fpl_team) { FactoryGirl.create(:fpl_team, user: user, league: league, rank: 10) }
  let!(:fpl_team2) { FactoryGirl.create(:fpl_team, league: league, rank: 9) }
  let!(:fpl_team3) { FactoryGirl.create(:fpl_team, league: league, rank: 8) }
  before do
    3.times do
      FactoryGirl.create(:player, position: Position.find_by(singular_name_short: 'FWD'))
    end

    5.times do
      FactoryGirl.create(:player, position: Position.find_by(singular_name_short: 'MID'))
    end

    5.times do
      FactoryGirl.create(:player, position: Position.find_by(singular_name_short: 'DEF'))
    end

    2.times do
      FactoryGirl.create(:player, position: Position.find_by(singular_name_short: 'GKP'))
    end
    fpl_team.players << Player.all
    league.players << Player.all
    FactoryGirl.create(:round, name: 'Gameweek 1', deadline_time: 2.weeks.ago, is_current: false)
    ::FplTeams::ProcessInitialLineUp.run(fpl_team: fpl_team)
  end

  it 'successfully creates a mini draft pick' do
    round = FactoryGirl.create(:round, name: 'Gameweek 2', deadline_time: 1.weeks.ago, is_current: false)
    mini_draft_round = FactoryGirl.create(
      :round,
      name: 'Gameweek 3',
      deadline_time: Round::SUMMER_MINI_DRAFT_DEADLINE + 3.days,
      is_current: true,
      mini_draft: true
    )
    in_player = FactoryGirl.create(:player, position: Position.find_by(singular_name_short: 'MID'))
    in_player.update(created_at: round.deadline_time, updated_at: round.deadline_time)
    list_position = ListPosition.midfielders.first
    out_player = list_position.player
    fpl_team_list = FplTeamList.first
    fpl_team_list.update(round: mini_draft_round)

    outcome = described_class.run(
      league: league,
      fpl_team_list_id: FplTeamList.first.id,
      current_user: user,
      list_position_id: list_position.id,
      player_id: in_player.id
    )
    expect(outcome).to be_valid
    expect(fpl_team_list.reload.players).to include(in_player)
    expect(fpl_team_list.reload.players).not_to include(out_player)
    expect(fpl_team.reload.players).to include(in_player)
    expect(fpl_team.reload.players).not_to include(out_player)
    expect(league.reload.players).to include(in_player)
    expect(league.reload.players).not_to include(out_player)
    expect(MiniDraftPick.first.in_player).to eq(in_player)
    expect(MiniDraftPick.first.out_player).to eq(out_player)
    expect(outcome.league_decorator.current_draft_pick.fpl_team).to eq(fpl_team2)
  end
end
