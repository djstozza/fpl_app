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
    Round.create(name: 'Gameweek 1', deadline_time: 7.days.ago, is_current: true, data_checked: true)
    Round.create(name: 'Gameweek 2', deadline_time: 3.days.from_now, is_next: true, data_checked: false)
    ::FplTeams::ProcessInitialLineUp.run(fpl_team: fpl_team)
    FplTeamList.first.update(round: Round.second)
    @list_position = ListPosition.midfielders.first
    @out_player = @list_position.player
    @in_player = FactoryGirl.create(
      :player,
      position: Position.find_by(singular_name_short: 'MID'),
      team: FactoryGirl.create(:team)
    )
  end

  it 'successfully creates the waiver pick, increasing the pick number incrementally' do
    form = ::FplTeams::CreateWaiverPickForm.new(
      fpl_team_list: FplTeamList.first,
      list_position: @list_position,
      in_player: @in_player,
      current_user: user
    )
    expect { form.save }.to change(WaiverPick, :count).by(1)
    expect(WaiverPick.first.pick_number).to eq(1)
    expect(WaiverPick.first.out_player).to eq(@out_player)
    expect(WaiverPick.first.in_player).to eq(@in_player)

    ::FplTeams::CreateWaiverPickForm.new(
      fpl_team_list: FplTeamList.first,
      list_position: ListPosition.midfielders.second,
      in_player: @in_player,
      current_user: user
    ).save

    expect(WaiverPick.second.pick_number).to eq(2)
  end

  it 'fails to create the waiver pick if not authorised' do
    form = ::FplTeams::CreateWaiverPickForm.new(
      fpl_team_list: FplTeamList.first,
      list_position: @list_position,
      in_player: @in_player,
      current_user: FactoryGirl.create(:user)
    )
    expect { form.save }.to change(WaiverPick, :count).by(0)
    expect(form.errors.full_messages).to include('You are not authorised to make changes to this team.')
  end

  it 'fails if the player being traded out in the waiver is not a member of the fpl team' do
    fpl_team.players.delete(@out_player)
    form = ::FplTeams::CreateWaiverPickForm.new(
      fpl_team_list: FplTeamList.first,
      list_position: @list_position,
      in_player: @in_player,
      current_user: user
    )
    expect { form.save }.to change(WaiverPick, :count).by(0)
    expect(form.errors.full_messages).to include('You can only trade out players that are part of your team.')
  end

  it 'fails if the waiver cutoff time has passed' do
    Round.second.update(deadline_time: 2.day.from_now - 1.minute)
    form = ::FplTeams::CreateWaiverPickForm.new(
      fpl_team_list: FplTeamList.first,
      list_position: @list_position,
      in_player: @in_player,
      current_user: user
    )
    expect { form.save }.to change(WaiverPick, :count).by(0)
    expect(form.errors.full_messages).to include('The deadline time for making waiver picks this round has passed.')
  end

  it "fails if the fpl team already has three players that are from the in_player's team" do
    @in_player.update(team: team)
    form = ::FplTeams::CreateWaiverPickForm.new(
      fpl_team_list: FplTeamList.first,
      list_position: @list_position,
      in_player: @in_player,
      current_user: user
    )
    expect { form.save }.to change(WaiverPick, :count).by(0)
    expect(form.errors.full_messages).to include(
      "You can't have more than #{::FplTeams::CreateWaiverPickForm::QUOTAS[:team]} players from the same team " \
        "(#{@in_player.team.name})."
    )
  end

  it 'prevents duplicate waiver picks' do
    ::FplTeams::CreateWaiverPickForm.new(
      fpl_team_list: FplTeamList.first,
      list_position: @list_position,
      in_player: @in_player,
      current_user: user
    ).save

    form = ::FplTeams::CreateWaiverPickForm.new(
      fpl_team_list: FplTeamList.first,
      list_position: @list_position,
      in_player: @in_player,
      current_user: user
    )
    expect { form.save }.to change(WaiverPick, :count).by(0)
    expect(form.errors.full_messages).to include(
      "Duplicate waiver pick - (Pick number: #{WaiverPick.first.pick_number} " \
        "Out: #{@out_player.last_name} In: #{@in_player.last_name})."
    )
  end

  it 'prevents picks occuring during the first round' do
    FplTeamList.first.update(round: Round.first)
    form = ::FplTeams::CreateWaiverPickForm.new(
      fpl_team_list: FplTeamList.first,
      list_position: @list_position,
      in_player: @in_player,
      current_user: user
    )
    expect { form.save }.to change(WaiverPick, :count).by(0)
    expect(form.errors.full_messages).to include('There are no waiver picks during the first round.')
  end
end
