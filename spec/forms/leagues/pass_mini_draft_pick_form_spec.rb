require 'rails_helper'

RSpec.describe Leagues::PassMiniDraftPickForm, type: :form do
  let(:user) { FactoryBot.create(:user) }
  let(:league) { FactoryBot.create(:league, commissioner: user) }
  let!(:fpl_team1) { FactoryBot.create(:fpl_team, user: user, league: league, rank: 4) }
  let!(:fpl_team2) { FactoryBot.create(:fpl_team, league: league, rank: 3) }
  let!(:fpl_team3) { FactoryBot.create(:fpl_team, league: league, rank: 2) }
  let!(:fpl_team4) { FactoryBot.create(:fpl_team, league: league, rank: 1) }

  before do
    FactoryBot.create(
      :round,
      deadline_time: (Round::SUMMER_MINI_DRAFT_DEADLINE + 3.days),
      is_current: true,
      mini_draft: true
    )
    FplTeam.all.each do |fpl_team|
      3.times do
        FactoryBot.create(:player, position: Position.find_by(singular_name_short: 'FWD'))
      end

      5.times do
        FactoryBot.create(:player, position: Position.find_by(singular_name_short: 'MID'))
      end

      5.times do
        FactoryBot.create(:player, position: Position.find_by(singular_name_short: 'DEF'))
      end

      2.times do
        FactoryBot.create(:player, position: Position.find_by(singular_name_short: 'GKP'))
      end

      fpl_team.players << Player.no_fpl_teams

      ::FplTeams::ProcessInitialLineUp.run!(fpl_team: fpl_team)
    end
    league.players << Player.all
  end

  it 'successfully passes the mini draft pick' do
    # Fpl team 1 passes for the first time - next fpl team is fpl team 2
    outcome = described_class.run(
      league: league,
      fpl_team_list_id: fpl_team1.fpl_team_lists.first.id,
      current_user: user
    )
    expect(outcome).to be_valid
    expect(outcome.league_decorator.next_fpl_team).to eq(fpl_team2)

    in_player = FactoryBot.create(:player, position: Position.find_by(singular_name_short: 'MID'))

    # Fpl team 2 picks - next fpl team is fpl team 3
    outcome = Leagues::ProcessMiniDraftPickForm.run(
      league: league,
      fpl_team_list_id: fpl_team2.fpl_team_lists.first.id,
      current_user: fpl_team2.user,
      list_position_id: fpl_team2.fpl_team_lists.first.list_positions.midfielders.first.id,
      player_id: in_player.id
    )

    expect(outcome).to be_valid
    expect(outcome.league_decorator.next_fpl_team).to eq(fpl_team3)


    in_player = FactoryBot.create(:player, position: Position.find_by(singular_name_short: 'MID'))

    # Fpl team 3 picks - next fpl team is fpl team 4
    outcome = Leagues::ProcessMiniDraftPickForm.run(
      league: league,
      fpl_team_list_id: fpl_team3.fpl_team_lists.first.id,
      current_user: fpl_team3.user,
      list_position_id: fpl_team3.fpl_team_lists.first.list_positions.midfielders.first.id,
      player_id: in_player.id
    )

    expect(outcome).to be_valid
    expect(outcome.league_decorator.next_fpl_team).to eq(fpl_team4)

    # fpl_team 4 passes - next fpl team is fpl team 4
    outcome = described_class.run(
      league: league,
      fpl_team_list_id: fpl_team4.fpl_team_lists.first.id,
      current_user: fpl_team4.user
    )

    expect(outcome).to be_valid
    expect(outcome.league_decorator.next_fpl_team).to eq(fpl_team4)

    # fpl_team 4 has passed for the second time in a row and will no longer be able to make a pick
    outcome = described_class.run(
      league: league,
      fpl_team_list_id: fpl_team4.fpl_team_lists.first.id,
      current_user: fpl_team4.user
    )
    expect(outcome).to be_valid
    expect(outcome.league_decorator.next_fpl_team).to eq(fpl_team3)

    in_player = FactoryBot.create(:player, position: Position.find_by(singular_name_short: 'MID'))

    # fpl_team 3 picks - next fpl team is fpl team 2
    outcome = Leagues::ProcessMiniDraftPickForm.run(
      league: league,
      fpl_team_list_id: fpl_team3.fpl_team_lists.first.id,
      current_user: fpl_team3.user,
      list_position_id: fpl_team3.fpl_team_lists.first.list_positions.midfielders.first.id,
      player_id: in_player.id
    )

    expect(outcome).to be_valid
    expect(outcome.league_decorator.next_fpl_team).to eq(fpl_team2)

    # fpl_team 2 passes - next fpl team is fpl team 1
    outcome = described_class.run(
      league: league,
      fpl_team_list_id: fpl_team2.fpl_team_lists.first.id,
      current_user: fpl_team2.user
    )
    expect(outcome).to be_valid
    expect(outcome.league_decorator.next_fpl_team).to eq(fpl_team1)

    # fpl_team 1 has passed for the second time in a row and will no longer be able to make a pick
    outcome = described_class.run(
      league: league,
      fpl_team_list_id: fpl_team1.fpl_team_lists.first.id,
      current_user: fpl_team1.user
    )

    expect(outcome).to be_valid
    expect(outcome.league_decorator.next_fpl_team).to eq(fpl_team2)

    # fpl_team 2 has passed for the second time in a row and will no longer be able to make a pick
    outcome = described_class.run(
      league: league,
      fpl_team_list_id: fpl_team2.fpl_team_lists.first.id,
      current_user: fpl_team2.user
    )

    expect(outcome).to be_valid
    expect(outcome.league_decorator.next_fpl_team).to eq(fpl_team3)

    # fpl_team 3 has passed - fpl team 3 only team left that doesn't have consecutive passes

    outcome = described_class.run(
      league: league,
      fpl_team_list_id: fpl_team3.fpl_team_lists.first.id,
      current_user: fpl_team3.user
    )

    expect(outcome).to be_valid
    expect(outcome.league_decorator.next_fpl_team).to eq(fpl_team3)

    # fpl_team 3 has passed - no teams left without consecutive passes

    outcome = described_class.run(
      league: league,
      fpl_team_list_id: fpl_team3.fpl_team_lists.first.id,
      current_user: fpl_team3.user
    )

    expect(outcome).to be_valid
    expect(outcome.league_decorator.next_fpl_team).to eq(nil)
  end
end
