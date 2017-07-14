require 'rails_helper'

RSpec.describe FplTeams::CreateWaiverPickForm, type: :form do
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
    Round.create(name: 'Gameweek 1', deadline_time: 3.days.from_now, is_current: true)
    ::FplTeams::ProcessInitialLineUp.run(fpl_team: fpl_team)
    @list_position = ListPosition.midfielders.first
    @player = @list_position.player
    @target = FactoryGirl.create(
      :player,
      position: Position.find_by(singular_name_short: 'MID'),
      team: FactoryGirl.create(:team)
    )
  end

  it 'successfully creates the waiver pick, increasing the pick number incrementally' do
    form = ::FplTeams::CreateWaiverPickForm.new(
      fpl_team: fpl_team,
      list_position: @list_position,
      target: @target,
      current_user: user
    )
    expect { form.save }.to change(WaiverPick, :count).by(1)
    expect(WaiverPick.first.pick_number).to eq(1)
    expect(WaiverPick.first.list_position.player).to eq(@player)
    expect(WaiverPick.first.player).to eq(@target)

    ::FplTeams::CreateWaiverPickForm.new(
      fpl_team: fpl_team,
      list_position: ListPosition.midfielders.second,
      target: @target,
      current_user: user
    ).save

    expect(WaiverPick.second.pick_number).to eq(2)
  end

  it 'fails to process the trade if not authorised' do
    form = ::FplTeams::CreateWaiverPickForm.new(
      fpl_team: fpl_team,
      list_position: @list_position,
      target: @target,
      current_user: FactoryGirl.create(:user)
    )
    expect { form.save }.to change(WaiverPick, :count).by(0)
    expect(form.errors.full_messages).to include('You are not authorised to make changes to this team.')
  end

  it 'fails if the player being traded out in the waiver is not a member of the fpl team' do
    fpl_team.players.delete(@player)
    form = ::FplTeams::CreateWaiverPickForm.new(
      fpl_team: fpl_team,
      list_position: @list_position,
      target: @target,
      current_user: user
    )
    expect { form.save }.to change(WaiverPick, :count).by(0)
    expect(form.errors.full_messages).to include('You can only trade out players that are part of your team.')
  end

  it 'fails if the waiver cutoff time has passed' do
    Round.first.update(deadline_time: 2.day.from_now - 1.minute)
    form = ::FplTeams::CreateWaiverPickForm.new(
      fpl_team: fpl_team,
      list_position: @list_position,
      target: @target,
      current_user: user
    )
    form.save
    expect(form.errors.full_messages).to include('The deadline time for making waiver picks this round has passed.')
  end


  it "fails if the fpl team already has three players that are from the target's team" do
    @target.update(team: team)
    form = ::FplTeams::CreateWaiverPickForm.new(
      fpl_team: fpl_team,
      list_position: @list_position,
      target: @target,
      current_user: user
    )
    form.save
    expect(form.errors.full_messages).to include(
      "You can't have more than #{::FplTeams::CreateWaiverPickForm::QUOTAS[:team]} players from the same team " \
        "(#{@target.team.name})."
    )
  end
end
