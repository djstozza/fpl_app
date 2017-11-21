require 'rails_helper'

RSpec.describe InterTeamTradeGroups::Approve do
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

    out_player = @out_fpl_team_list.list_positions.midfielders.second.player
    in_player = @in_fpl_team_list.list_positions.midfielders.second.player

    InterTeamTradeGroups::AddToGroup.run!(
      current_user: user,
      inter_team_trade_group: @trade_group,
      out_player: out_player,
      in_player: in_player
    )
  end

  it 'successfully approves trade group' do
    outcome = described_class.run(
      current_user: in_fpl_team.user,
      inter_team_trade_group: @trade_group
    )

    expect(outcome).to be_valid
    expect(@trade_group.in_players - out_fpl_team.players).to be_empty
    expect(@trade_group.out_players - out_fpl_team.players).not_to be_empty
    expect(@trade_group.out_players - in_fpl_team.players).to be_empty
    expect(@trade_group.in_players - in_fpl_team.players).not_to be_empty
    expect(@trade_group.in_players.map(&:id) - @out_fpl_team_list.list_positions.midfielders.map(&:player_id))
      .to be_empty
    expect(@trade_group.out_players.map(&:id) - @out_fpl_team_list.list_positions.midfielders.map(&:player_id))
      .not_to be_empty
    expect(@trade_group.out_players.map(&:id) - @in_fpl_team_list.list_positions.midfielders.map(&:player_id))
      .to be_empty
    expect(@trade_group.in_players.map(&:id) - @in_fpl_team_list.list_positions.midfielders.map(&:player_id))
      .not_to be_empty
    expect(@trade_group.approved?).to be_truthy
  end

  it 'fails if the round deadline time has passed' do
    Timecop.freeze(round.deadline_time + 1.second)

    outcome = described_class.run(
      current_user: in_fpl_team.user,
      inter_team_trade_group: @trade_group
    )

    expect(outcome).not_to be_valid
    expect(@trade_group.in_players - out_fpl_team.players).not_to be_empty
    expect(@trade_group.out_players - out_fpl_team.players).to be_empty
    expect(@trade_group.out_players - in_fpl_team.players).not_to be_empty
    expect(@trade_group.in_players - in_fpl_team.players).to be_empty
    expect(@trade_group.in_players.map(&:id) - @out_fpl_team_list.list_positions.midfielders.map(&:player_id))
      .not_to be_empty
    expect(@trade_group.out_players.map(&:id) - @out_fpl_team_list.list_positions.midfielders.map(&:player_id))
      .to be_empty
    expect(@trade_group.out_players.map(&:id) - @in_fpl_team_list.list_positions.midfielders.map(&:player_id))
      .not_to be_empty
    expect(@trade_group.in_players.map(&:id) - @in_fpl_team_list.list_positions.midfielders.map(&:player_id))
      .to be_empty
    expect(@trade_group.pending?).to be_truthy

    Timecop.return
  end

  it 'fails if the round is no longer current' do
    round.update(is_current: false)
    FactoryBot.create(:round)

    outcome = described_class.run(
      current_user: in_fpl_team.user,
      inter_team_trade_group: @trade_group
    )

    expect(outcome).not_to be_valid
    expect(@trade_group.in_players - out_fpl_team.players).not_to be_empty
    expect(@trade_group.out_players - out_fpl_team.players).to be_empty
    expect(@trade_group.out_players - in_fpl_team.players).not_to be_empty
    expect(@trade_group.in_players - in_fpl_team.players).to be_empty
    expect(@trade_group.in_players.map(&:id) - @out_fpl_team_list.list_positions.midfielders.map(&:player_id))
      .not_to be_empty
    expect(@trade_group.out_players.map(&:id) - @out_fpl_team_list.list_positions.midfielders.map(&:player_id))
      .to be_empty
    expect(@trade_group.out_players.map(&:id) - @in_fpl_team_list.list_positions.midfielders.map(&:player_id))
      .not_to be_empty
    expect(@trade_group.in_players.map(&:id) - @in_fpl_team_list.list_positions.midfielders.map(&:player_id))
      .to be_empty
    expect(@trade_group.pending?).to be_truthy
  end

  it 'fails if the trade group is no longer pending' do
    @trade_group.update(status: 'approved')

    outcome = described_class.run(
      current_user: in_fpl_team.user,
      inter_team_trade_group: @trade_group
    )

    expect(outcome).not_to be_valid
    expect(@trade_group.in_players - out_fpl_team.players).not_to be_empty
    expect(@trade_group.out_players - out_fpl_team.players).to be_empty
    expect(@trade_group.out_players - in_fpl_team.players).not_to be_empty
    expect(@trade_group.in_players - in_fpl_team.players).to be_empty
    expect(@trade_group.in_players.map(&:id) - @out_fpl_team_list.list_positions.midfielders.map(&:player_id))
      .not_to be_empty
    expect(@trade_group.out_players.map(&:id) - @out_fpl_team_list.list_positions.midfielders.map(&:player_id))
      .to be_empty
    expect(@trade_group.out_players.map(&:id) - @in_fpl_team_list.list_positions.midfielders.map(&:player_id))
      .not_to be_empty
    expect(@trade_group.in_players.map(&:id) - @in_fpl_team_list.list_positions.midfielders.map(&:player_id))
      .to be_empty
  end

  it 'fails if the user is not authorised' do
    outcome = described_class.run(
      current_user: user,
      inter_team_trade_group: @trade_group
    )

    expect(outcome).not_to be_valid

    expect(@trade_group.in_players - out_fpl_team.players).not_to be_empty
    expect(@trade_group.out_players - out_fpl_team.players).to be_empty
    expect(@trade_group.out_players - in_fpl_team.players).not_to be_empty
    expect(@trade_group.in_players - in_fpl_team.players).to be_empty
    expect(@trade_group.in_players.map(&:id) - @out_fpl_team_list.list_positions.midfielders.map(&:player_id))
      .not_to be_empty
    expect(@trade_group.out_players.map(&:id) - @out_fpl_team_list.list_positions.midfielders.map(&:player_id))
      .to be_empty
    expect(@trade_group.out_players.map(&:id) - @in_fpl_team_list.list_positions.midfielders.map(&:player_id))
      .not_to be_empty
    expect(@trade_group.in_players.map(&:id) - @in_fpl_team_list.list_positions.midfielders.map(&:player_id))
      .to be_empty
    expect(@trade_group.pending?).to be_truthy
  end
end
