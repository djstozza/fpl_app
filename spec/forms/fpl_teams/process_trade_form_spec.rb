require 'rails_helper'

RSpec.describe FplTeams::ProcessTradeForm, type: :form do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:league) { FactoryGirl.create(:league, commissioner: user) }
  let!(:fpl_team) { FactoryGirl.create(:fpl_team, user: user, league: league) }
  let!(:team) { FactoryGirl.create(:team) }

  before do
    3.times do
      FactoryGirl.create(:player, position: Position.find_by(singular_name_short: 'FWD'), team: team)
    end

    5.times do
      FactoryGirl.create(
        :player,
        position: Position.find_by(singular_name_short: 'MID'),
        team: FactoryGirl.create(:team)
      )
    end

    5.times do
      FactoryGirl.create(
        :player,
        position: Position.find_by(singular_name_short: 'DEF'),
        team: FactoryGirl.create(:team)
      )
    end

    2.times do
      FactoryGirl.create(
        :player,
        position: Position.find_by(singular_name_short: 'GKP'),
        team: FactoryGirl.create(:team)
      )
    end

    fpl_team.players << Player.all
    league.players << Player.all
    Round.create(name: 'Gameweek 1', deadline_time: 1.day.from_now, is_current: true)
    ::FplTeams::ProcessInitialLineUp.run(fpl_team: fpl_team)
    @list_position = ListPosition.midfielders.first
    @player = @list_position.player
    @target = FactoryGirl.create(
      :player,
      position: Position.find_by(singular_name_short: 'MID'),
      team: FactoryGirl.create(:team)
    )
  end

  it 'successfully processes the trade' do
    form = ::FplTeams::ProcessTradeForm.new(
      fpl_team: fpl_team,
      list_position: @list_position,
      target: @target,
      current_user: user
    )
    form.save
    expect(FplTeam.first.players.include?(@player)).to be_falsey
    expect(FplTeam.first.players.include?(@target)).to be_truthy
    expect(League.first.players.include?(@player)).to be_falsey
    expect(League.first.players.include?(@target)).to be_truthy
    expect(@list_position.player).to eq(@target)
  end

  it 'fails to process the trade if not authorised' do
    form = ::FplTeams::ProcessTradeForm.new(
      fpl_team: fpl_team,
      list_position: @list_position,
      target: @target,
      current_user: FactoryGirl.create(:user)
    )
    form.save
    expect(form.errors.full_messages).to include('You are not authorised to make changes to this team.')
    expect(FplTeam.first.players.include?(@player)).to be_truthy
    expect(FplTeam.first.players.include?(@target)).to be_falsey
    expect(League.first.players.include?(@player)).to be_truthy
    expect(League.first.players.include?(@target)).to be_falsey
    expect(@list_position.player).to eq(@player)
  end

  it 'fails if the target is already picked' do
    @target.leagues << league
    form = ::FplTeams::ProcessTradeForm.new(
      fpl_team: fpl_team,
      list_position: @list_position,
      target: @target,
      current_user: user
    )
    form.save
    expect(form.errors.full_messages).to include(
      'The player you are trying to trade into your team is owned by another team in your league.'
    )
  end

  it 'fails if the player being traded out is not a member of the fpl team' do
    fpl_team.players.delete(@player)
    form = ::FplTeams::ProcessTradeForm.new(
      fpl_team: fpl_team,
      list_position: @list_position,
      target: @target,
      current_user: user
    )
    form.save
    expect(form.errors.full_messages).to include('You can only trade out players that are part of your team.')
  end

  it 'allows trades if there round has no waiver cutoff (i.e. Round 1)' do
    Round.first.update(deadline_time: 2.days.from_now)
    ::FplTeams::ProcessTradeForm.new(
      fpl_team: fpl_team,
      list_position: @list_position,
      target: @target,
      current_user: user
    ).save
    expect(FplTeam.first.players.include?(@player)).to be_falsey
    expect(FplTeam.first.players.include?(@target)).to be_truthy
    expect(League.first.players.include?(@player)).to be_falsey
    expect(League.first.players.include?(@target)).to be_truthy
    expect(@list_position.player).to eq(@target)
  end

  it 'fails if the round has a waiver cutoff' do
    Round.first.update(data_checked: true)
    Round.create(name: 'Gameweek 2', is_next: true, deadline_time: 7.days.from_now, data_checked: false)
    ::FplTeams::ProcessNextLineUp.run!(
      fpl_team: fpl_team,
      current_round: Round.find_by(is_current: true),
      next_round: Round.find_by(is_next: true)
    )
    form = ::FplTeams::ProcessTradeForm.new(
      fpl_team: fpl_team,
      list_position: fpl_team.fpl_team_lists.second.list_positions.find_by(player: @list_position.player),
      target: @target,
      current_user: user
    )
    form.save
    expect(form.errors.full_messages).to include('You cannot trade players until the waiver cutoff time has passed.')
  end

  it 'fails if the trade occurs after the deadline time has passed' do
    Round.first.update(deadline_time: 1.minute.ago)
    form = ::FplTeams::ProcessTradeForm.new(
      fpl_team: fpl_team,
      list_position: @list_position,
      target: @target,
      current_user: user
    )
    form.save
    expect(form.errors.full_messages).to include('The deadline time for making trades has passed.')
  end

  it "fails if the fpl team already has three players that are from the target's team" do
    @target.update(team: team)
    form = ::FplTeams::ProcessTradeForm.new(
      fpl_team: fpl_team,
      list_position: @list_position,
      target: @target,
      current_user: user
    )
    form.save
    expect(form.errors.full_messages).to include(
      "You can't have more than #{::FplTeams::ProcessTradeForm::QUOTAS[:team]} players from the same team " \
        "(#{@target.team.name})."
    )
  end
end
