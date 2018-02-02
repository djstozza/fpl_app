require 'rails_helper'

RSpec.describe Leagues::JoinLeagueForm, type: :form do
  let(:user) { FactoryBot.create(:user) }
  let(:league) do
    FactoryBot.create(
      :league,
      name: 'league 1',
      code: SecureRandom.hex,
      commissioner: FactoryBot.create(:user)
    )
  end

  it 'successfully joins a league' do
    name = 'fpl team 1'
    outcome = described_class.run(
      current_user: user,
      league_name: league.name,
      code: league.code,
      fpl_team_name: name
    )

    expect(outcome.fpl_team.name).to eq(name)
    expect(outcome.fpl_team.league).to eq(league)
    expect(outcome.fpl_team.user).to eq(user)
  end

  it 'requires a leauge name' do
    outcome = described_class.run(
      current_user: user,
      code: league.code,
      fpl_team_name: 'fpl team 1'
    )

    expect(outcome.errors.full_messages).to include('League name is required')
  end

  it 'requires a code' do
    outcome = described_class.run(
      current_user: user,
      league_name: league.name,
      fpl_team_name: 'fpl team 1'
    )
    expect(outcome.errors.full_messages).to include('Code is required')
  end

  it 'does not join a league and create a team if the league name or code is incorrect' do
    outcome = described_class.run(
      current_user: user,
      league_name: league.name,
      code: 'incorrect',
      fpl_team_name: 'fpl team 1'
    )

    expect(outcome.errors.full_messages).to include('The league name and/or code you have entered is incorrect.')

    outcome = described_class.run(
      current_user: user,
      league_name: 'incorrect',
      code: league.code,
      fpl_team_name: 'fpl team 1'
    )

    expect(outcome.errors.full_messages).to include('The league name and/or code you have entered is incorrect.')
  end

  it 'requires a unique fpl team name' do
    fpl_team = FactoryBot.create(:fpl_team, user: FactoryBot.create(:user), league: league)
    outcome = described_class.run(
      current_user: user,
      league_name: league.name,
      code: league.code,
      fpl_team_name: fpl_team.name
    )

    expect(outcome.errors.full_messages).to include('Fpl team name has already been taken.')
  end

  it 'prevents a user joining a team more than once' do
    FactoryBot.create(:fpl_team, user: user, league: league)

    outcome = described_class.run(
      current_user: user,
      league_name: league.name,
      code: league.code,
      fpl_team_name: 'fpl team 2'
    )

    expect(outcome.errors.full_messages).to include('You have already joined this league')
  end

  it 'prevents a user from joining if the fpl team limit has been reached' do
    described_class::MAX_FPL_TEAM_QUOTA.times do
      FactoryBot.create(:fpl_team, user: FactoryBot.create(:user), league: league)
    end

    outcome = described_class.run(
      current_user: user,
      league_name: league.name,
      code: league.code,
      fpl_team_name: 'fpl team 12'
    )

    expect(outcome.errors.full_messages).to include('The limit on fpl teams for this league has already been reached.')
  end
end
