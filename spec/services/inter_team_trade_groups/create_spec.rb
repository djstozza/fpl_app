require 'rails_helper'

RSpec.describe InterTeamTradeGroups::Create do
  let!(:user) { FactoryBot.create(:user) }
  let!(:league) { FactoryBot.create(:league, commissioner: user) }
  let!(:out_fpl_team) { FactoryBot.create(:fpl_team, league: league, user: user) }
  let!(:in_fpl_team) { FactoryBot.create(:fpl_team, league: league) }
  let!(:round) { FactoryBot.create(:round) }

  before do
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

  it 'successfully creates an inter_team_trade_group' do
    out_fpl_team_list = out_fpl_team.fpl_team_lists.first
    in_fpl_team_list = in_fpl_team.fpl_team_lists.first

    out_player = out_fpl_team_list.list_positions.midfielders.first.player
    in_player = in_fpl_team_list.list_positions.midfielders.first.player

    outcome = described_class.run(
      current_user: user,
      out_fpl_team_list: out_fpl_team.fpl_team_lists.first,
      in_fpl_team_list: in_fpl_team.fpl_team_lists.first,
      out_player: out_player,
      in_player: in_player
    )

    expect(outcome).to be_valid

    trade_group = outcome.inter_team_trade_group.reload
    inter_team_trade = trade_group.inter_team_trades.first

    expect(trade_group.out_fpl_team_list).to eq(out_fpl_team_list)
    expect(trade_group.in_fpl_team_list).to eq(in_fpl_team_list)
    expect(trade_group.pending?).to be_truthy

    expect(trade_group.out_players).to include(out_player)
    expect(trade_group.in_players).to include(in_player)

    expect(inter_team_trade.out_player).to eq(out_player)
    expect(inter_team_trade.in_player).to eq(in_player)
  end

  it 'fails if the round deadline time has passed' do
    Timecop.freeze(round.deadline_time + 1.second)

    out_fpl_team_list = out_fpl_team.fpl_team_lists.first
    in_fpl_team_list = in_fpl_team.fpl_team_lists.first

    out_player = out_fpl_team_list.list_positions.midfielders.first.player
    in_player = in_fpl_team_list.list_positions.midfielders.first.player

    outcome = described_class.run(
      current_user: user,
      out_fpl_team_list: out_fpl_team.fpl_team_lists.first,
      in_fpl_team_list: in_fpl_team.fpl_team_lists.first,
      out_player: out_player,
      in_player: in_player
    )

    expect(outcome).not_to be_valid
    Timecop.return
  end

  it 'fails if the player positions are not identical' do
    out_fpl_team_list = out_fpl_team.fpl_team_lists.first
    in_fpl_team_list = in_fpl_team.fpl_team_lists.first

    out_player = out_fpl_team_list.list_positions.midfielders.first.player
    in_player = in_fpl_team_list.list_positions.forwards.first.player

    outcome = described_class.run(
      current_user: user,
      out_fpl_team_list: out_fpl_team.fpl_team_lists.first,
      in_fpl_team_list: in_fpl_team.fpl_team_lists.first,
      round: round,
      out_player: out_player,
      in_player: in_player
    )

    expect(outcome).not_to be_valid
  end

  it 'fails if the round is no longer current' do
    round.update(is_current: false)
    FactoryBot.create(:round)

    out_fpl_team_list = out_fpl_team.fpl_team_lists.first
    in_fpl_team_list = in_fpl_team.fpl_team_lists.first

    out_player = out_fpl_team_list.list_positions.midfielders.first.player
    in_player = in_fpl_team_list.list_positions.midfielders.first.player

    outcome = described_class.run(
      current_user: user,
      out_fpl_team_list: out_fpl_team.fpl_team_lists.first,
      in_fpl_team_list: in_fpl_team.fpl_team_lists.first,
      round: round,
      out_player: out_player,
      in_player: in_player
    )

    expect(outcome).not_to be_valid
  end

  it 'fails if the player is not in the in_fpl_team_list' do
    out_fpl_team_list = out_fpl_team.fpl_team_lists.first
    in_fpl_team_list = in_fpl_team.fpl_team_lists.first

    out_player = out_fpl_team_list.list_positions.midfielders.first.player
    in_player = in_fpl_team_list.list_positions.midfielders.first.player

    in_fpl_team.players.delete(in_player)

    outcome = described_class.run(
      current_user: user,
      out_fpl_team_list: out_fpl_team.fpl_team_lists.first,
      in_fpl_team_list: in_fpl_team.fpl_team_lists.first,
      round: round,
      out_player: out_player,
      in_player: in_player
    )

    expect(outcome).not_to be_valid
  end

  it 'fails if the player is not in the out_fpl_team_list' do
    out_fpl_team_list = out_fpl_team.fpl_team_lists.first
    in_fpl_team_list = in_fpl_team.fpl_team_lists.first

    out_player = out_fpl_team_list.list_positions.midfielders.first.player
    in_player = in_fpl_team_list.list_positions.midfielders.first.player

    out_fpl_team.players.delete(out_player)

    outcome = described_class.run(
      current_user: user,
      out_fpl_team_list: out_fpl_team.fpl_team_lists.first,
      in_fpl_team_list: in_fpl_team.fpl_team_lists.first,
      round: round,
      out_player: out_player,
      in_player: in_player
    )

    expect(outcome).not_to be_valid
  end
end
