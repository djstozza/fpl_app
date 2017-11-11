require 'rails_helper'

RSpec.describe Leagues::PassMiniDraftPickForm, type: :form do
  let(:user) { FactoryGirl.create(:user) }
  let(:league) { FactoryGirl.create(:league, commissioner: user) }
  let!(:fpl_team1) { FactoryGirl.create(:fpl_team, user: user, league: league, rank: 4) }
  let!(:fpl_team2) { FactoryGirl.create(:fpl_team, league: league, rank: 3) }
  let!(:fpl_team3) { FactoryGirl.create(:fpl_team, league: league, rank: 2) }
  let!(:fpl_team4) { FactoryGirl.create(:fpl_team, league: league, rank: 1) }

  before do
    FactoryGirl.create(
      :round,
      deadline_time: (Round::SUMMER_MINI_DRAFT_DEADLINE + 3.days),
      is_current: true,
      mini_draft: true
    )
    FplTeam.all.each do |fpl_team|
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

      fpl_team.players << Player.no_fpl_teams

      ::FplTeams::ProcessInitialLineUp.run!(fpl_team: fpl_team)
    end
    league.players << Player.all
  end

  it 'successfully passes the mini draft pick' do
    # fpl_team 1 has passed and will no longer be able to make a pick
    outcome = described_class.run(
      league: league,
      fpl_team_list_id: fpl_team1.fpl_team_lists.first.id,
      current_user: user
    )
    expect(outcome).to be_valid
    expect(outcome.league_decorator.next_fpl_team).to eq(fpl_team2)

    in_player = FactoryGirl.create(:player, position: Position.find_by(singular_name_short: 'MID'))

    outcome = Leagues::ProcessMiniDraftPickForm.run(
      league: league,
      fpl_team_list_id: fpl_team2.fpl_team_lists.first.id,
      current_user: fpl_team2.user,
      list_position_id: fpl_team2.fpl_team_lists.first.list_positions.midfielders.first.id,
      player_id: in_player.id
    )

    expect(outcome).to be_valid
    expect(outcome.league_decorator.next_fpl_team).to eq(fpl_team3)

    in_player = FactoryGirl.create(:player, position: Position.find_by(singular_name_short: 'MID'))

    outcome = Leagues::ProcessMiniDraftPickForm.run(
      league: league,
      fpl_team_list_id: fpl_team3.fpl_team_lists.first.id,
      current_user: fpl_team3.user,
      list_position_id: fpl_team3.fpl_team_lists.first.list_positions.midfielders.first.id,
      player_id: in_player.id
    )

    expect(outcome).to be_valid
    expect(outcome.league_decorator.next_fpl_team).to eq(fpl_team4)

    # fpl_team 4 has passed and will no longer be able to make a pick
    outcome = described_class.run(
      league: league,
      fpl_team_list_id: fpl_team4.fpl_team_lists.first.id,
      current_user: fpl_team4.user
    )

    expect(outcome).to be_valid
    expect(outcome.league_decorator.next_fpl_team).to eq(fpl_team3)

    # fpl_team 3 has passed and will no longer be able to make a pick
    outcome = described_class.run(
      league: league,
      fpl_team_list_id: fpl_team3.fpl_team_lists.first.id,
      current_user: fpl_team3.user
    )
    expect(outcome).to be_valid
    expect(outcome.league_decorator.next_fpl_team).to eq(fpl_team2)

    in_player = FactoryGirl.create(:player, position: Position.find_by(singular_name_short: 'MID'))

    # fpl_team 2 is only able to make a pick since all other fpl teams have passed
    outcome = Leagues::ProcessMiniDraftPickForm.run(
      league: league,
      fpl_team_list_id: fpl_team2.fpl_team_lists.first.id,
      current_user: fpl_team2.user,
      list_position_id: fpl_team2.fpl_team_lists.first.list_positions.midfielders.first.id,
      player_id: in_player.id
    )

    expect(outcome).to be_valid
    expect(outcome.league_decorator.next_fpl_team).to eq(fpl_team2)

    # No more fpl teams left in the mini draft
    outcome = described_class.run(
      league: league,
      fpl_team_list_id: fpl_team2.fpl_team_lists.first.id,
      current_user: fpl_team2.user
    )
    expect(outcome).to be_valid
    expect(outcome.league_decorator.next_fpl_team).to eq(nil)
  end
end
