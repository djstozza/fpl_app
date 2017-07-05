require 'rails_helper'

RSpec.describe FplTeams::ProcessSubstitutionForm, type: :form do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:league) { FactoryGirl.create(:league, commissioner: user) }
  let!(:fpl_team) { FactoryGirl.create(:fpl_team, user: user, league: league) }

  before do
    i = 0
    3.times do
      i += 1
      FactoryGirl.create(:player, position: Position.find_by(singular_name_short: 'FWD'), ict_index: i)
    end

    5.times do
      i += 1
      FactoryGirl.create(:player, position: Position.find_by(singular_name_short: 'MID'), ict_index: i)
    end

    5.times do
      i += 1
      FactoryGirl.create(:player, position: Position.find_by(singular_name_short: 'DEF'), ict_index: i)
    end

    2.times do
      i += 1
      FactoryGirl.create(:player, position: Position.find_by(singular_name_short: 'GKP'), ict_index: i)
    end

    fpl_team.players << Player.all
    Round.create(name: 'Gameweek 1', deadline_time: 1.day.from_now)
  end

  it 'successfully substitutes players' do
    ::FplTeams::ProcessInitialLineUp.run(fpl_team: fpl_team)
    fpl_team_list = FplTeamList.first
    player = fpl_team_list.list_positions.starting.first.player
    original_count = fpl_team_list.list_positions.starting.where(position: player.position).count
    target = fpl_team_list.list_positions.find_by(role: 'substitute_1').player
    form = FplTeams::ProcessSubstitutionForm.new(
      fpl_team_list: fpl_team_list,
      player: player,
      target: target,
      current_user: user
    )
    form.save
    expect(fpl_team_list.list_positions.starting.where(position: player.position).count < original_count).to be_truthy
    expect(fpl_team_list.list_positions.starting.find_by(player: player)).to be_nil
    expect(fpl_team_list.list_positions.find_by(player: target).role).to eq('starting')
    expect(fpl_team_list.list_positions.find_by(role: 'substitute_1').player).to eq(player)
  end

  it 'makes sure that there is at least one forward' do
    fpl_team_list = FplTeamList.create(fpl_team: fpl_team, round: Round.first)
    fpl_team_decorator = FplTeamDecorator.new(fpl_team)
    forward = fpl_team_decorator.players_by_position(position: 'forwards').first
    starting = []
    starting << forward
    starting += fpl_team_decorator.players_by_position(position: 'midfielders', order: 'ict_index').first(4)
    starting += fpl_team_decorator.players_by_position(position: 'defenders', order: 'ict_index')
    starting << fpl_team_decorator.players_by_position(position: 'goalkeepers', order: 'ict_index').first
    starting.each do |player|
      ListPosition.create(player: player, position: player.position, fpl_team_list: fpl_team_list, role: 'starting')
    end
    left_over_players = fpl_team_decorator.players - starting
    i = 0
    left_over_players.each do |player|
      if player.position.singular_name == 'Goalkeeper'
        ListPosition.create(
          player: player,
          position: player.position,
          fpl_team_list: fpl_team_list,
          role: 'substitute_gkp'
        )
      else
        i += 1
        ListPosition.create(
          player: player,
          position: player.position,
          fpl_team_list: fpl_team_list,
          role: "substitute_#{i}"
        )
      end
    end

    target = fpl_team_decorator.players_by_position(position: 'midfielders', order: 'ict_index').last
    form = FplTeams::ProcessSubstitutionForm.new(
      fpl_team_list: fpl_team_list,
      player: forward.id,
      target: target,
      current_user: user
    )
    form.save
    expect(form.errors.full_messages).to include('There must be at least one forward in the starting line up.')
    expect(fpl_team_list.list_positions.starting.find_by(player: forward)).not_to be_nil
    expect(fpl_team_list.list_positions.find_by(player: target).role).not_to eq('starting')
  end

  it 'makes sure that there are at least 3 midfielders' do
    ::FplTeams::ProcessInitialLineUp.run(fpl_team: fpl_team)
    fpl_team_list = FplTeamList.first
    defender = fpl_team_list.list_positions.starting.defenders.first.player
    target = fpl_team_list.list_positions.where.not(role: 'starting').midfielders.first.player
    form = FplTeams::ProcessSubstitutionForm.new(
      fpl_team_list: fpl_team_list,
      player: defender.id,
      target: target,
      current_user: user
    )
    form.save
    expect(form.errors.full_messages).to include('There must be at least three defenders in the starting line up.')
    expect(fpl_team_list.list_positions.starting.find_by(player: defender)).not_to be_nil
    expect(fpl_team_list.list_positions.find_by(player: target).role).not_to eq('starting')
  end

  it 'prevents unauthorised users from making changes' do
    ::FplTeams::ProcessInitialLineUp.run(fpl_team: fpl_team)
    fpl_team_list = FplTeamList.first
    form = FplTeams::ProcessSubstitutionForm.new(
      fpl_team_list: fpl_team_list,
      player: fpl_team_list.list_positions.starting.midfielders.first.player,
      target: fpl_team_list.list_positions.find_by(role: 'substitute_1').player,
      current_user: FactoryGirl.create(:user)
    )
    form.save
    expect(form.errors.full_messages).to include('You are not authorised to make changes to this team.')
  end

  it 'prevents substitutions if the deadline time has passed' do
    ::FplTeams::ProcessInitialLineUp.run(fpl_team: fpl_team)
    Round.update(deadline_time: 1.minute.ago)
    fpl_team_list = FplTeamList.first
    form = FplTeams::ProcessSubstitutionForm.new(
      fpl_team_list: fpl_team_list,
      player: fpl_team_list.list_positions.starting.midfielders.first.player,
      target: fpl_team_list.list_positions.find_by(role: 'substitute_1').player,
      current_user: user
    )
    form.save
    expect(form.errors.full_messages).to include('The deadline time for making substitutions has passed.')
  end
end
