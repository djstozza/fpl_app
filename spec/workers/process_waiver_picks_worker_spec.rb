require 'rails_helper'

RSpec.describe ProcessWaiverPicksWorker do
  before do
    Round.create(name: 'Gameweek 1', is_current: true, data_checked: true, deadline_time: 4.days.ago)
    Round.create(
      name: 'Gameweek 2',
      is_current: false,
      is_next: true,
      deadline_time: 1.week.from_now,
      data_checked: false
    )
    10.times do
      user = FactoryGirl.create(:user)
      FactoryGirl.create(:league, commissioner: user) if user == User.first
      fpl_team = FactoryGirl.create(:fpl_team, league: League.first, user: user)
      3.times do
        fpl_team.players << FactoryGirl.create(:player, position: Position.find_by(singular_name_short: 'FWD'))
      end

      5.times do
        fpl_team.players << FactoryGirl.create(
          :player,
          position: Position.find_by(singular_name_short: 'MID'),
          team: FactoryGirl.create(:team)
        )
      end

      5.times do
        fpl_team.players << FactoryGirl.create(
          :player,
          position: Position.find_by(singular_name_short: 'DEF'),
          team: FactoryGirl.create(:team)
        )
      end

      2.times do
        fpl_team.players << FactoryGirl.create(
          :player,
          position: Position.find_by(singular_name_short: 'GKP'),
          team: FactoryGirl.create(:team)
        )
      end
      ::FplTeams::ProcessInitialLineUp.run!(fpl_team: fpl_team)
      Player.all.each do |player|
        player.update(
          player_fixture_histories: [{
            'round' => Round.first.id,
            'minutes' => 90,
            'total_points' => Faker::Number.number(1).to_i,
            'kickoff_time' => 2.minutes.ago
          }]
        )
      end
    end

    League.first.update(active: true)
    ScoringWorker.new.perform
    i = 10
    10.times do
      instance_variable_set(
        "@waiver_player_#{i}", FactoryGirl.create(:player, position: Position.find_by(singular_name_short: 'FWD'))
      )

      j = 1
      "#{i}".to_i.times do
        create_waiver_pick(FplTeam.find_by(rank: j), instance_variable_get("@waiver_player_#{i}"))
        j += 1
      end
      i -= 1
    end

    ProcessWaiverPicksWorker.new.perform
  end

  it 'successfully processes all waiver picks, approving those that are valid and declining those that are not' do
    i = 1
    10.times do
      in_player = instance_variable_get("@waiver_player_#{i}")
      waiver_pick = WaiverPick.find_by(in_player: in_player, status: 'approved')
      league = League.first
      expect(league.players.include?(in_player)).to be_truthy
      fpl_team = FplTeam.find_by(rank: i)
      list_position_players = waiver_pick.fpl_team_list.list_positions.map { |list_position| list_position.player }
      expect(fpl_team.players.include?(in_player)).to be_truthy
      expect(league.players.include?(player: waiver_pick.out_player)).to be_falsey
      expect(fpl_team.players.include?(player: waiver_pick.out_player)).to be_falsey
      expect(list_position_players.include?(in_player)).to be_truthy
      expect(list_position_players.include?(waiver_pick.out_player)).to be_falsey
      expect(fpl_team.waiver_picks.where.not(in_player: in_player)).to eq(fpl_team.waiver_picks.declined)
      expect(fpl_team.waiver_picks.pending).to be_empty
      i += 1
    end
  end

  private

  def create_waiver_pick(fpl_team, player)
    current_round_id = RoundsDecorator.new(Round.all).current_round.id
    fpl_team_list = fpl_team.fpl_team_lists.find_by(round_id: current_round_id)
    ::FplTeams::CreateWaiverPickForm.run!(
      fpl_team: fpl_team,
      fpl_team_list: fpl_team_list,
      list_position_id: fpl_team_list.list_positions.forwards.first.id,
      target_id: player.id,
      current_user: fpl_team.user
    )
  end
end
