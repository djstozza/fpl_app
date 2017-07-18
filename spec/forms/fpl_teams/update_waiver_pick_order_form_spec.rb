require 'rails_helper'

RSpec.describe FplTeams::UpdateWaiverPickOrderForm, type: :form do
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
    3.times do
      ::FplTeams::CreateWaiverPickForm.new(
        fpl_team_list: FplTeamList.first,
        list_position: ListPosition.midfielders.first,
        in_player: FactoryGirl.create(
          :player,
          position: Position.find_by(singular_name_short: 'MID'),
          team: FactoryGirl.create(:team)
        ),
        current_user: user
      ).save
    end
  end

  it 'successfully reorders the waiver picks - reducing pick number' do
    waiver_pick = WaiverPick.last
    expect(waiver_pick.pick_number).to eq(WaiverPick.count)
    form = ::FplTeams::UpdateWaiverPickOrderForm.new(
      fpl_team_list: FplTeamList.first,
      waiver_pick: waiver_pick,
      new_pick_number: 2,
      current_user: user
    )
    form.save
    expect(waiver_pick.pick_number).to eq(2)
    expect(WaiverPick.first.pick_number).to eq(1)
    expect(WaiverPick.second.pick_number).to eq(3)
  end

  it 'successfully reorders the waiver picks - increasing pick number' do
    waiver_pick = WaiverPick.second
    expect(waiver_pick.pick_number).to eq(2)
    form = ::FplTeams::UpdateWaiverPickOrderForm.new(
      fpl_team_list: FplTeamList.first,
      waiver_pick: waiver_pick,
      new_pick_number: 3,
      current_user: user
    )
    form.save
    expect(waiver_pick.pick_number).to eq(3)
    expect(WaiverPick.first.pick_number).to eq(1)
    expect(WaiverPick.third.pick_number).to eq(2)
  end

  it 'does not change the order of waiver picks if the new pick number is the same as the old one' do
    waiver_pick = WaiverPick.second
    form = ::FplTeams::UpdateWaiverPickOrderForm.new(
      fpl_team_list: FplTeamList.first,
      waiver_pick: waiver_pick,
      new_pick_number: 2,
      current_user: user
    )
    form.save
    expect(form.errors.full_messages).to include('No change in pick number.')
    expect(waiver_pick.pick_number).to eq(2)
    expect(WaiverPick.first.pick_number).to eq(1)
    expect(WaiverPick.last.pick_number).to eq(3)
  end

  it 'fails to re-order the waiver picks if not authorised' do
    waiver_pick = WaiverPick.last
    form = ::FplTeams::UpdateWaiverPickOrderForm.new(
      fpl_team_list: FplTeamList.first,
      waiver_pick: waiver_pick,
      new_pick_number: 2,
      current_user: FactoryGirl.create(:user)
    )
    form.save
    expect(form.errors.full_messages).to include('You are not authorised to make changes to this team.')
    expect(waiver_pick.pick_number).to eq(3)
    expect(WaiverPick.first.pick_number).to eq(1)
    expect(WaiverPick.second.pick_number).to eq(2)
  end

  it 'fails if the waiver cutoff time has passed' do
    Round.first.update(deadline_time: 2.day.from_now - 1.minute)
    waiver_pick = WaiverPick.last
    form = ::FplTeams::UpdateWaiverPickOrderForm.new(
      fpl_team_list: FplTeamList.first,
      waiver_pick: waiver_pick,
      new_pick_number: 2,
      current_user: user
    )
    form.save
    expect(form.errors.full_messages).to include('The deadline time for updating waiver picks this round has passed.')
    expect(waiver_pick.pick_number).to eq(3)
    expect(WaiverPick.first.pick_number).to eq(1)
    expect(WaiverPick.second.pick_number).to eq(2)
  end

  it 'fails if the round is not current' do
    Round.first.update(is_current: false)
    Round.create(name: 'Gameweek 2', deadline_time: 3.days.from_now, is_current: true)
    waiver_pick = WaiverPick.last
    form = ::FplTeams::UpdateWaiverPickOrderForm.new(
      fpl_team_list: FplTeamList.first,
      waiver_pick: waiver_pick,
      new_pick_number: 2,
      current_user: user
    )
    form.save
    expect(form.errors.full_messages).to include(
      "You can only make changes to your squad's line up for the upcoming round."
    )
    expect(waiver_pick.pick_number).to eq(3)
    expect(WaiverPick.first.pick_number).to eq(1)
    expect(WaiverPick.second.pick_number).to eq(2)
  end

  it 'fails if the waiver picks have already been processed' do
    WaiverPick.update_all(status: 'approved')
    waiver_pick = WaiverPick.last
    form = ::FplTeams::UpdateWaiverPickOrderForm.new(
      fpl_team_list: FplTeamList.first,
      waiver_pick: waiver_pick,
      new_pick_number: 2,
      current_user: user
    )
    form.save
    expect(form.errors.full_messages).to include('You can only edit pending waiver picks.')
    expect(waiver_pick.pick_number).to eq(3)
    expect(WaiverPick.first.pick_number).to eq(1)
    expect(WaiverPick.second.pick_number).to eq(2)
  end

  it 'fails if the pick number is invalid' do
    waiver_pick = WaiverPick.last
    form = ::FplTeams::UpdateWaiverPickOrderForm.new(
      fpl_team_list: FplTeamList.first,
      waiver_pick: waiver_pick,
      new_pick_number: 4,
      current_user: user
    )
    form.save
    expect(form.errors.full_messages).to include('Pick number is invalid.')
  end
end
