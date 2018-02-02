require 'rails_helper'

RSpec.describe InterTeamTradeGroups::AddToGroup do
  let!(:user) { FactoryBot.create(:user) }
  let!(:league) { FactoryBot.create(:league, commissioner: user) }
  let!(:out_fpl_team) { FactoryBot.create(:fpl_team, league: league, user: user) }
  let!(:in_fpl_team) { FactoryBot.create(:fpl_team, league: league) }
  let!(:round) { FactoryBot.create(:round) }

  before do
    FplTeam.all.each do |fpl_team|
      team = FactoryBot.create(:team)
      3.times do
        FactoryBot.create(:player, position: Position.find_by(singular_name_short: 'FWD'), team: team)
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

    @out_fpl_team_list = out_fpl_team.fpl_team_lists.first
    @in_fpl_team_list = in_fpl_team.fpl_team_lists.first

    out_player = @out_fpl_team_list.list_positions.midfielders.first.player
    in_player = @in_fpl_team_list.list_positions.midfielders.first.player

    @trade_group = InterTeamTradeGroups::Create.run(
      current_user: user,
      out_fpl_team_list: out_fpl_team.fpl_team_lists.first,
      in_fpl_team_list: in_fpl_team.fpl_team_lists.first,
      out_player: out_player,
      in_player: in_player
    ).result
  end

  it 'successfully adds to the trade group' do
    out_player = @out_fpl_team_list.list_positions.forwards.first.player
    in_player = @in_fpl_team_list.list_positions.forwards.first.player

    outcome = described_class.run(
      current_user: user,
      inter_team_trade_group: @trade_group,
      out_player: out_player,
      in_player: in_player
    )

    expect(outcome).to be_valid

    trade_group = outcome.inter_team_trade_group.reload

    expect(trade_group.inter_team_trades.count).to eq(2)

    trade = trade_group.inter_team_trades.last
    expect(trade.out_player).to eq(out_player)
    expect(trade.in_player).to eq(in_player)
  end

  it 'fails if the round deadline time has passed' do
    Timecop.freeze(round.deadline_time + 1.second)

    out_player = @out_fpl_team_list.list_positions.forwards.first.player
    in_player = @in_fpl_team_list.list_positions.forwards.first.player

    outcome = described_class.run(
      current_user: user,
      inter_team_trade_group: @trade_group,
      out_player: out_player,
      in_player: in_player
    )

    expect(outcome).not_to be_valid
    Timecop.return
  end

  it 'fails if the round is no longer current' do
    round.update(is_current: false)
    FactoryBot.create(:round)

    out_player = @out_fpl_team_list.list_positions.forwards.first.player
    in_player = @in_fpl_team_list.list_positions.forwards.first.player

    outcome = described_class.run(
      current_user: user,
      inter_team_trade_group: @trade_group,
      out_player: out_player,
      in_player: in_player
    )

    expect(outcome).not_to be_valid
  end

  it 'fails if team quotas are not observed (out_fpl_team)' do
    out_player = @out_fpl_team_list.list_positions.midfielders.first.player
    team = @out_fpl_team_list.list_positions.forwards.first.player.team

    in_player = @in_fpl_team_list.list_positions.midfielders.first.player
    in_player.update(team: team)

    outcome = described_class.run(
      current_user: user,
      inter_team_trade_group: @trade_group,
      out_player: out_player,
      in_player: in_player
    )

    expect(outcome).not_to be_valid
  end

  it 'fails if team quotas are not observed (in_fpl_team)' do
    in_player = @in_fpl_team_list.list_positions.midfielders.second.player

    team = @in_fpl_team_list.list_positions.forwards.first.player.team

    out_player = @out_fpl_team_list.list_positions.midfielders.second.player
    out_player.update(team: team)

    outcome = described_class.run(
      current_user: user,
      inter_team_trade_group: @trade_group,
      out_player: out_player,
      in_player: in_player
    )

    expect(outcome).not_to be_valid
  end

  it 'fails if the player is not in the in_fpl_team_list' do
    out_player = @out_fpl_team_list.list_positions.forwards.first.player
    in_player = @in_fpl_team_list.list_positions.forwards.first.player

    in_fpl_team.players.delete(in_player)

    outcome = described_class.run(
      current_user: user,
      inter_team_trade_group: @trade_group,
      out_player: out_player,
      in_player: in_player
    )

    expect(outcome).not_to be_valid
  end

  it 'fails if the player is not in the out_fpl_team_list' do
    out_player = @out_fpl_team_list.list_positions.forwards.first.player
    in_player = @in_fpl_team_list.list_positions.forwards.first.player

    out_fpl_team.players.delete(out_player)

    outcome = described_class.run(
      current_user: user,
      inter_team_trade_group: @trade_group,
      out_player: out_player,
      in_player: in_player
    )

    expect(outcome).not_to be_valid
  end

  it 'fails if the out_player already appears in the trade group' do
    out_player = @out_fpl_team_list.list_positions.midfielders.first.player
    in_player = @in_fpl_team_list.list_positions.forwards.second.player

    outcome = described_class.run(
      current_user: user,
      inter_team_trade_group: @trade_group,
      out_player: out_player,
      in_player: in_player
    )

    expect(outcome).not_to be_valid
  end

  it 'fails if the in_player already appears in the trade group' do
    out_player = @out_fpl_team_list.list_positions.midfielders.second.player
    in_player = @in_fpl_team_list.list_positions.forwards.first.player

    outcome = described_class.run(
      current_user: user,
      inter_team_trade_group: @trade_group,
      out_player: out_player,
      in_player: in_player
    )

    expect(outcome).not_to be_valid
  end
end
