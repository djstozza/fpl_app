require 'rails_helper'

RSpec.describe FplTeams::CreateWaiverPickForm, type: :form do
  let!(:user) { FactoryBot.create(:user) }
  let!(:league) { FactoryBot.create(:league, commissioner: user) }
  let!(:fpl_team) { FactoryBot.create(:fpl_team, user: user, league: league) }
  let!(:team) { FactoryBot.create(:team) }

  before do
    3.times do
      FactoryBot.create(:player, position: Position.find_by(singular_name_short: 'FWD'), team: team)
    end

    5.times do
      FactoryBot.create(
        :player,
        position: Position.find_by(singular_name_short: 'MID'),
        team: FactoryBot.create(:team)
      )
    end

    5.times do
      FactoryBot.create(
        :player,
        position: Position.find_by(singular_name_short: 'DEF'),
        team: FactoryBot.create(:team)
      )
    end

    2.times do
      FactoryBot.create(
        :player,
        position: Position.find_by(singular_name_short: 'GKP'),
        team: FactoryBot.create(:team)
      )
    end

    fpl_team.players << Player.all
    league.players << Player.all
    Round.create(name: 'Gameweek 1', deadline_time: 7.days.ago, is_current: true, data_checked: true)
    Round.create(name: 'Gameweek 2', deadline_time: 3.days.from_now, is_next: true, data_checked: false)
    ::FplTeams::ProcessInitialLineUp.run(fpl_team: fpl_team)
    FplTeamList.first.update(round: Round.second)
    @list_position = ListPosition.midfielders.first
    @out_player = @list_position.player
    @in_player = FactoryBot.create(
      :player,
      position: Position.find_by(singular_name_short: 'MID'),
      team: FactoryBot.create(:team)
    )
  end

  it 'successfully creates the waiver pick, increasing the pick number incrementally' do
    outcome = ::FplTeams::CreateWaiverPickForm.run(
      fpl_team_list: FplTeamList.first,
      fpl_team: fpl_team,
      list_position_id: @list_position.id,
      target_id: @in_player.id,
      current_user: user
    )
    expect(outcome).to be_valid

    waiver_pick = outcome.waiver_picks.last
    expect(waiver_pick.pick_number).to eq(1)
    expect(waiver_pick.out_player).to eq(@out_player)
    expect(waiver_pick.in_player).to eq(@in_player)

    ::FplTeams::CreateWaiverPickForm.run(
      fpl_team_list: FplTeamList.first,
      fpl_team: fpl_team,
      list_position_id: ListPosition.midfielders.second.id,
      target_id: @in_player.id,
      current_user: user
    )

    expect(WaiverPick.second.pick_number).to eq(2)
  end

  it 'fails to create the waiver pick if not authorised' do
    outcome = ::FplTeams::CreateWaiverPickForm.run(
      fpl_team_list: FplTeamList.first,
      fpl_team: fpl_team,
      list_position_id: @list_position.id,
      target_id: @in_player.id,
      current_user: FactoryBot.create(:user)
    )

    expect(outcome).not_to be_valid
    expect(outcome.errors.full_messages).to include('You are not authorised to make changes to this team.')
  end

  it 'fails if the player being traded out in the waiver is not a member of the fpl team' do
    fpl_team.players.delete(@out_player)
    outcome = ::FplTeams::CreateWaiverPickForm.run(
      fpl_team_list: FplTeamList.first,
      fpl_team: fpl_team,
      list_position_id: @list_position.id,
      target_id: @in_player.id,
      current_user: user
    )

    expect(outcome).not_to be_valid
    expect(outcome.errors.full_messages).to include('You can only trade out players that are part of your team.')
  end

  it 'fails if the waiver cutoff time has passed' do
    Round.second.update(deadline_time: 1.day.from_now - 1.minute)
    outcome = ::FplTeams::CreateWaiverPickForm.run(
      fpl_team_list: FplTeamList.first,
      fpl_team: fpl_team,
      list_position_id: @list_position.id,
      target_id: @in_player.id,
      current_user: user
    )

    expect(outcome).not_to be_valid
    expect(outcome.errors.full_messages).to include('The deadline time for making waiver picks this round has passed.')
  end

  it "fails if the fpl team already has three players that are from the in_player's team" do
    @in_player.update(team: team)
    outcome = ::FplTeams::CreateWaiverPickForm.run(
      fpl_team_list: FplTeamList.first,
      fpl_team: fpl_team,
      list_position_id: @list_position.id,
      target_id: @in_player.id,
      current_user: user
    )

    expect(outcome).not_to be_valid
    expect(outcome.errors.full_messages).to include(
      "You can't have more than #{::FplTeam::QUOTAS[:team]} players from the same team " \
        "(#{@in_player.team.name})."
    )
  end

  it 'prevents duplicate waiver picks' do
    ::FplTeams::CreateWaiverPickForm.run(
      fpl_team_list: FplTeamList.first,
      fpl_team: fpl_team,
      list_position_id: @list_position.id,
      target_id: @in_player.id,
      current_user: user
    )

    outcome = ::FplTeams::CreateWaiverPickForm.run(
      fpl_team_list: FplTeamList.first,
      fpl_team: fpl_team,
      list_position_id: @list_position.id,
      target_id: @in_player.id,
      current_user: user
    )

    expect(outcome).not_to be_valid
    expect(outcome.errors.full_messages).to include(
      "Duplicate waiver pick - (Pick number: #{WaiverPick.first.pick_number} " \
        "Out: #{@out_player.last_name} In: #{@in_player.last_name})."
    )
  end

  it 'prevents picks occuring during the first round' do
    FplTeamList.first.update(round: Round.first)
    outcome = ::FplTeams::CreateWaiverPickForm.run(
      fpl_team_list: FplTeamList.first,
      fpl_team: fpl_team,
      list_position_id: @list_position.id,
      target_id: @in_player.id,
      current_user: user
    )

    expect(outcome).not_to be_valid
    expect(outcome.errors.full_messages).to include('There are no waiver picks during the first round.')
  end
end
