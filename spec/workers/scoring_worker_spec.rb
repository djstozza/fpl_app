require 'rails_helper'

RSpec.describe ScoringWorker do
  before do
    Round.create(name: 'Gameweek 1', is_current: true, data_checked: true, deadline_time: 4.days.ago)
    10.times do
      user = FactoryBot.create(:user)
      FactoryBot.create(:league, commissioner: user) if user == User.first
      fpl_team = FactoryBot.create(:fpl_team, league: League.first, user: user)
      3.times do
        fpl_team.players << FactoryBot.create(:player, position: Position.find_by(singular_name_short: 'FWD'))
      end

      5.times do
        fpl_team.players << FactoryBot.create(
          :player,
          position: Position.find_by(singular_name_short: 'MID'),
          team: FactoryBot.create(:team)
        )
      end

      5.times do
        fpl_team.players << FactoryBot.create(
          :player,
          position: Position.find_by(singular_name_short: 'DEF'),
          team: FactoryBot.create(:team)
        )
      end

      2.times do
        fpl_team.players << FactoryBot.create(
          :player,
          position: Position.find_by(singular_name_short: 'GKP'),
          team: FactoryBot.create(:team)
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
    Round.create(
      name: 'Gameweek 2',
      is_current: false,
      is_next: true,
      deadline_time: 1.week.from_now,
      data_checked: false
    )
    League.first.update(active: true)
  end

  it 'scores and ranks the fpl team lists and fpl teams' do
    ScoringWorker.new.perform
    10.times do
      i = 0
      j = i + 1
      current_round = Round.find_by(is_current: true)
      next_round = Round.find_by(is_next: true)
      fpl_team = FplTeam.find_by(rank: j)
      expect(fpl_team).to eq(FplTeam.order(total_score: :desc)[i])
      expect(FplTeamList.find_by(rank: j)).to eq(FplTeamList.where(round: current_round).order(total_score: :desc)[i])
      expect(fpl_team.fpl_team_lists.find_by(round: current_round).players)
        .to eq(fpl_team.fpl_team_lists.find_by(round: next_round).players)
      expect(fpl_team.fpl_team_lists.find_by(round: next_round).rank).to be_nil
      i += 1
    end
  end

  it 'does not perform scoring if the the round is not data checked' do
    Round.first.update(data_checked: false)
    ScoringWorker.new.perform
    expect(FplTeam.all.all? { |fpl_team| fpl_team.rank.nil? }).to be_truthy
    expect(FplTeam.all.all? { |fpl_team| fpl_team.fpl_team_lists.count == 1}).to be_truthy
    expect(FplTeamList.all.all? { |fpl_team_list| fpl_team_list.rank.nil? }).to be_truthy
  end

  it 'does not peform scoring if already processed' do
    FplTeam.all.sort.each_with_index { |fpl_team, i| fpl_team.update(rank: i + 1) }
    FplTeamList.all.sort.each_with_index { |fpl_team_list, i| fpl_team_list.update(rank: i + 1) }
    FplTeam.order(rank: :desc).each_with_index { |fpl_team, i| fpl_team.update(total_score: i) }
    FplTeamList.order(rank: :desc).each_with_index { |fpl_team_list, i| fpl_team_list.update(total_score: i) }
    ScoringWorker.new.perform
    expect(FplTeam.all.all? { |fpl_team| fpl_team.fpl_team_lists.count == 1}).to be_truthy
  end
end
