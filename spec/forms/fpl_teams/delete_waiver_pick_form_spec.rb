require 'rails_helper'

RSpec.describe FplTeams::DeleteWaiverPickForm, type: :form do
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
    Round.create(name: 'Gameweek 1', deadline_time: 7.days.ago, is_current: true, data_checked: true)
    Round.create(name: 'Gameweek 2', deadline_time: 3.days.from_now, is_next: true, data_checked: false)
    ::FplTeams::ProcessInitialLineUp.run(fpl_team: fpl_team)
    FplTeamList.first.update(round: Round.second)
    3.times do
      ::FplTeams::CreateWaiverPickForm.run!(
        fpl_team: fpl_team,
        fpl_team_list: FplTeamList.first,
        list_position_id: ListPosition.midfielders.first.id,
        target_id: FactoryGirl.create(
          :player,
          position: Position.find_by(singular_name_short: 'MID'),
          team: FactoryGirl.create(:team)
        ).id,
        current_user: user
      )
    end
  end

  it 'successfully deletes a waiver pick - updating the waiver pick numbers' do
    waiver_pick = WaiverPick.first
    second_waiver_pick = WaiverPick.second
    third_waiver_pick = WaiverPick.third

    expect {
      described_class.run(
        fpl_team: fpl_team,
        fpl_team_list: FplTeamList.first,
        waiver_pick: waiver_pick,
        current_user: user
      )
    }.to change(WaiverPick, :count).by(-1)
    expect(fpl_team.waiver_picks).not_to include(waiver_pick)
    expect(WaiverPick.find_by(id: second_waiver_pick.id).pick_number).to eq(1)
    expect(WaiverPick.find_by(id: third_waiver_pick.id).pick_number).to eq(2)
  end

  it 'fails to delete the waiver pick if not authorised' do
    waiver_pick = WaiverPick.last
    form = described_class.run(
      fpl_team: fpl_team,
      fpl_team_list: FplTeamList.first,
      waiver_pick: waiver_pick,
      current_user: FactoryGirl.create(:user)
    )
    expect(form).not_to be_valid
    expect(form.errors.full_messages).to include('You are not authorised to make changes to this team.')
    expect(fpl_team.waiver_picks).to include(waiver_pick)
  end

  it 'fails if the waiver cutoff time has passed' do
    Round.second.update(deadline_time: 1.day.from_now - 1.minute)
    waiver_pick = WaiverPick.last
    form = described_class.run(
      fpl_team: fpl_team,
      fpl_team_list: FplTeamList.first,
      waiver_pick: waiver_pick,
      current_user: user
    )
    expect(form).not_to be_valid
    expect(form.errors.full_messages).to include('The deadline time for updating waiver picks this round has passed.')
    expect(fpl_team.waiver_picks).to include(waiver_pick)
  end

  it 'fails if the round is not current' do
    Round.first.update(is_current: false, is_previous: true)
    Round.second.update(is_current: true, is_next: false, data_checked: true, deadline_time: 1.day.ago)
    Round.create(name: 'Gameweek 3', deadline_time: 3.days.from_now, is_next: true, data_checked: false)
    waiver_pick = WaiverPick.last
    form = described_class.run(
      fpl_team: fpl_team,
      fpl_team_list: FplTeamList.first,
      waiver_pick: waiver_pick,
      current_user: user
    )
    expect(form).not_to be_valid
    expect(form.errors.full_messages).to include(
      "You can only make changes to your squad's line up for the upcoming round."
    )
    expect(fpl_team.waiver_picks).to include(waiver_pick)
  end

  it 'fails if the waiver picks have already been processed' do
    WaiverPick.update_all(status: 'approved')
    waiver_pick = WaiverPick.last
    form = described_class.run(
      fpl_team: fpl_team,
      fpl_team_list: FplTeamList.first,
      waiver_pick: waiver_pick,
      current_user: user
    )
    expect(form).not_to be_valid
    expect(form.errors.full_messages).to include('You can only delete pending waiver picks.')
    expect(fpl_team.waiver_picks).to include(waiver_pick)
  end
end
