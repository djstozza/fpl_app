require 'rails_helper'

RSpec.describe Leagues::ProcessWaiverPicksWorker do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:league) { FactoryGirl.create(:league, commissioner: user) }
  let!(:fpl_team) { FactoryGirl.create(:fpl_team, league: league, user: user) }

  before do
    Round.create(name: 'Gameweek 1', is_current: true, data_checked: true, deadline_time: 4.days.ago)

    3.times do
      FactoryGirl.create(:player, position: Position.find_by(singular_name_short: 'FWD'))
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
    ::FplTeams::ProcessInitialLineUp.run!(fpl_team: fpl_team)
  end

  # 3-4-3 means 3 forwards, 4 midfielders, 3 defenders in starting line up
  scenario 'formaion: 3-4-3, all starting players played' do
    Player.all.each do |player|
      player.update(
        player_fixture_histories: [{
          'round' => Round.first.id,
          'minutes' => 90,
          'total_points' => Faker::Number.number(1).to_i,
          'kickoff_time' => 2.hours.ago
        }]
      )
    end

    ::Leagues::ProcessScoringService.run!(league: league, round: Round.find_by(is_current: true))

    expect(FplTeamList.first.total_score).to eq(starting_players_total_score)
    expect(FplTeam.first.total_score).to eq(FplTeamList.first.total_score)
  end

  scenario 'formation: 3-4-3, no forwards played minutes' do
    ListPosition.forwards.each_with_index do |list_position, i|
      list_position.player.update(
        player_fixture_histories: [{
          'round' => Round.first.id,
          'minutes' => 0,
          'total_points' => 0,
          'kickoff_time' => "#{i}".to_i.minutes.ago.to_time
        }]
      )
    end

    ListPosition.where.not(position: Position.find_by(singular_name: 'Forward')).each do |list_position|
      list_position.player.update(
        player_fixture_histories: [{
          'round' => Round.first.id,
          'minutes' => 90,
          'total_points' => Faker::Number.number(1).to_i,
          'kickoff_time' => 10.minutes.ago
        }]
      )
    end
    sub_1_player = ListPosition.find_by(role: 'substitute_1').player
    sub_2_player = ListPosition.find_by(role: 'substitute_2').player
    ::Leagues::ProcessScoringService.run!(league: league, round: Round.find_by(is_current: true))
    expect(ListPosition.starting.forwards.count).to eq(1)
    expect(ListPosition.starting.count).to eq(11)
    starting_players = ListPosition.starting.map { |list_position| list_position.player }
    expect(starting_players).to include(sub_1_player)
    expect(starting_players).to include(sub_2_player)
    second_fwd_pos = ListPosition.forwards.second
    third_fwd_pos = ListPosition.forwards.third

    # The third forward's fixture had an earlier kickoff_time so was substituted first
    expect(history_kickoff_time(second_fwd_pos)).to be > (history_kickoff_time(third_fwd_pos))
    expect(ListPosition.forwards.third.role).to eq('substitute_1')
    expect(ListPosition.forwards.second.role).to eq('substitute_2')
    expect(FplTeamList.first.total_score).to eq(starting_players_total_score)
    expect(FplTeam.first.total_score).to eq(FplTeamList.first.total_score)
  end

  # 2-5-3 means 2 fowrads, 5 midfielders and 3 defenders in starting line up
  scenario 'formation: 2-5-3, 1 starting defender played' do
    # Substitute midfielder role is substitute 1
    first_fwd_pos = ListPosition.forwards.first
    ListPosition.find_by(role: 'substitute_1').update(role: 'starting')
    first_fwd_pos.update(role: 'substitute_1')
    first_fwd_pos.player.update(
      player_fixture_histories: [{
        'round' => Round.first.id,
        'minutes' => 90,
        'total_points' => 1_000,
        'kickoff_time' => 2.hours.ago
      }]
    )

    ListPosition.starting.defenders[0..1].each_with_index do |list_position, i|
      list_position.player.update(
        player_fixture_histories: [{
          'round' => Round.first.id,
          'minutes' => 0,
          'total_points' => 0,
          'kickoff_time' => "#{i}".to_i.minutes.ago.to_time
        }]
      )
    end

    first_starting_def = ListPosition.starting.defenders.first.player
    second_starting_def = ListPosition.starting.defenders.second.player
    first_sub_defender = ListPosition.find_by(role: 'substitute_2').player
    second_sub_defender = ListPosition.find_by(role: 'substitute_3').player

    ListPosition.starting.defenders.last.player.update(
      player_fixture_histories: [{
        'round' => Round.first.id,
        'minutes' => 90,
        'total_points' => 90,
        'kickoff_time' => 2.minutes.ago
      }]
    )

    list_positions = ListPosition.all - ListPosition.starting.defenders
    list_positions.delete_if { |list_position| list_position == first_fwd_pos }
    list_positions.each do |list_position|
      list_position.player.update(
        player_fixture_histories: [{
          'round' => Round.first.id,
          'minutes' => 90,
          'total_points' => Faker::Number.number(1).to_i,
          'kickoff_time' => 2.minutes.ago
        }]
      )
    end

    ::Leagues::ProcessScoringService.run!(league: league, round: Round.find_by(is_current: true))
    # Even though substitute 1 is a forward, that player doesn't start because there must be at least 3 starting
    # defenders.
    # This means that substitute 2 (defender) and substitute 3 (defender) are used to replace the two starting defenders
    # who didn't play
    expect(first_fwd_pos.role).to eq('substitute_1')
    expect(scores_arr(Round.first)).not_to include(first_fwd_pos.player.player_fixture_histories.first['total_points'])

    starting_players = ListPosition.starting.map { |list_position| list_position.player }
    expect(starting_players).to include(first_sub_defender)
    expect(starting_players).to include(second_sub_defender)
    # Second starting defender had an earlier match and was therefore subsituted first
    expect(ListPosition.find_by(role: 'substitute_2').player).to eq(second_starting_def)
    expect(ListPosition.find_by(role: 'substitute_3').player).to eq(first_starting_def)
    expect(FplTeamList.first.total_score).to eq(starting_players_total_score)
    expect(FplTeam.first.total_score).to eq(FplTeamList.first.total_score)
  end


  scenario 'starting player with two fixtures in the round did not play in the first but did play in the second' do
    first_fwd_pos = ListPosition.forwards.first
    first_fwd_pos.player.update(
      player_fixture_histories: [
        {
          'round' => Round.first.id,
          'minutes' => 0,
          'total_points' => 0,
          'kickoff_time' => 10.minutes.ago
        },
        {
          'round' => Round.first.id,
          'minutes' => 1,
          'total_points' => Faker::Number.number(1).to_i,
          'kickoff_time' => 2.minutes.ago
        }
      ]
    )

    ListPosition.all.to_a.delete_if { |list_position| list_position == first_fwd_pos }.each do |list_position|
      list_position.player.update(
        player_fixture_histories: [{
          'round' => Round.first.id,
          'minutes' => 90,
          'total_points' => Faker::Number.number(1).to_i,
          'kickoff_time' => 2.minutes.ago
        }]
      )
    end

    ::Leagues::ProcessScoringService.run!(league: league, round: Round.find_by(is_current: true))
    expect(ListPosition.starting.forwards.count).to eq(3)
    expect(FplTeamList.first.total_score).to eq(starting_players_total_score)
    expect(FplTeam.first.total_score).to eq(FplTeamList.first.total_score)
  end

  scenario 'starting player with two fixtures did not play in either of them' do
    first_fwd_pos = ListPosition.forwards.first
    first_fwd_player = ListPosition.forwards.first.player
    first_fwd_player.update(
      player_fixture_histories: [
        {
          'round' => Round.first.id,
          'minutes' => 0,
          'total_points' => 0,
          'kickoff_time' => 10.minutes.ago
        },
        {
          'round' => Round.first.id,
          'minutes' => 0,
          'total_points' => 0,
          'kickoff_time' => 2.minutes.ago
        }
      ]
    )

    ListPosition.all.to_a.delete_if { |list_position| list_position == first_fwd_pos }.each do |list_position|
      list_position.player.update(
        player_fixture_histories: [{
          'round' => Round.first.id,
          'minutes' => 90,
          'total_points' => Faker::Number.number(1).to_i,
          'kickoff_time' => 2.minutes.ago
        }]
      )
    end

    ::Leagues::ProcessScoringService.run!(league: league, round: Round.find_by(is_current: true))
    expect(ListPosition.starting.forwards.count).to eq(2)
    expect(ListPosition.find_by(player: first_fwd_player).substitute_1?).to be_truthy
    expect(FplTeamList.first.total_score).to eq(starting_players_total_score)
    expect(FplTeam.first.total_score).to eq(FplTeamList.first.total_score)
  end

  scenario 'goalkeeper did not play' do
    starting_gkp = ListPosition.goalkeepers.find_by(role: 'starting').player
    starting_gkp.update(
      player_fixture_histories: [{
        'round' => Round.first.id,
        'minutes' => 0,
        'total_points' => Faker::Number.number(1).to_i,
        'kickoff_time' => 2.minutes.ago
      }]
    )

    substitute_gkp = ListPosition.goalkeepers.find_by(role: 'substitute_gkp').player

    ListPosition.all.to_a.delete_if { |list_position| list_position.player == starting_gkp }.each do |list_position|
      list_position.player.update(
        player_fixture_histories: [{
          'round' => Round.first.id,
          'minutes' => 90,
          'total_points' => Faker::Number.number(1).to_i,
          'kickoff_time' => 2.minutes.ago
        }]
      )
    end

    ::Leagues::ProcessScoringService.run!(league: league, round: Round.find_by(is_current: true))
    expect(ListPosition.find_by(player: starting_gkp).substitute_gkp?).to be_truthy
    expect(ListPosition.find_by(player: substitute_gkp).starting?).to be_truthy
    expect(FplTeamList.first.total_score).to eq(starting_players_total_score)
    expect(FplTeam.first.total_score).to eq(FplTeamList.first.total_score)
  end

  scenario 'second round is current' do
    Round.create(
      name: 'Gameweek 2',
      is_current: false,
      is_next: true,
      data_checked: false,
      deadline_time: 7.days.from_now
    )
    Player.all.each do |player|
      player.update(
        player_fixture_histories: [{
          'round' => Round.first.id,
          'minutes' => 90,
          'total_points' => Faker::Number.number(1).to_i,
          'kickoff_time' => 2.hours.ago
        }]
      )
    end
    ::Leagues::ProcessScoringService.run!(league: league, round: Round.find_by(is_current: true))
    ::FplTeams::ProcessNextLineUp.run!(
      fpl_team: fpl_team,
      current_round: Round.find_by(is_current: true),
      next_round: Round.find_by(is_next: true)
    )

    Round.first.update(is_current: false, is_previous: true, deadline_time: 1.week.ago)
    Round.second.update(is_current: true, is_next: false, deadline_time: 2.days.ago, data_checked: true)

    Player.all.each do |player|
      player.update(
        player_fixture_histories: [
          player.player_fixture_histories.first,
          {
            'round' => Round.second.id,
            'minutes' => 90,
            'total_points' => Faker::Number.number(1).to_i,
            'kickoff_time' => 2.hours.ago
          }
        ]
      )
    end

    ::Leagues::ProcessScoringService.run!(league: league, round: Round.find_by(is_current: true))
    expect(FplTeamList.second.total_score).to eq(starting_players_total_score)
    expect(FplTeamList.first.total_score).to eq(starting_players_total_score(Round.find_by(is_previous: true)))
    expect(FplTeam.first.total_score).to eq(FplTeamList.first.total_score + FplTeamList.second.total_score)
  end

  private

  def player_fixture_history(player, round)
    player.player_fixture_histories.select { |pfh| pfh['round'] == round.id }
  end

  def player_score(player, round)
    pfh = player_fixture_history(player, round)
    return 0 if pfh.empty?
    pfh.inject(0) { |sum, x| sum +  x['total_points'].to_i }
  end

  def history_kickoff_time(list_position)
    list_position.player.player_fixture_histories.first['kickoff_time']
  end

  def scores_arr(round)
    FplTeamList.find_by(round: round).list_positions.starting.map do |list_position|
      player_score(list_position.player, round)
    end
  end

  def starting_players_total_score(round = Round.find_by(is_current: true))
    scores_arr(round).inject(0) { |sum, x| sum + x }
  end
end
