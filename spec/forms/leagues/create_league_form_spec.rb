require 'rails_helper'

RSpec.describe Leagues::CreateLeagueForm, type: :form do
  it 'successfully creates a league and fpl team' do
    user = FactoryBot.create(:user)
    form = described_class.run(
      current_user: user,
      name: Faker::GameOfThrones.house,
      fpl_team_name: Faker::Team.name,
      code: SecureRandom.hex(6)
    )

    expect(League.first.name).to eq(form.league.name)
    expect(League.first.code).to eq(form.league.code)
    expect(League.first.commissioner).to eq(user)
    expect(FplTeam.first).to eq(form.fpl_team)
    expect(FplTeam.first.league).to eq(League.first)
    expect(FplTeam.first.user).to eq(user)
  end

  it 'requires a league name (unique), code and fpl team name (unique)' do
    user = FactoryBot.build_stubbed(:user)
    form = described_class.run(
      current_user: user,
      code: SecureRandom.hex(6),
      fpl_team_name: Faker::Team.name
    )
    expect(form.errors.full_messages).to include("Name can't be blank")

    form = described_class.run(
      current_user: user,
      code: SecureRandom.hex(6),
      name: Faker::GameOfThrones.house
    )
    expect(form.errors.full_messages).to include('Fpl team name is required')

    form = described_class.run(
      current_user: user,
      name: Faker::GameOfThrones.house,
      fpl_team_name: Faker::Team.name
    )

    expect(form.errors.full_messages).to include("Code can't be blank")

    user = FactoryBot.create(:user)
    team_name = Faker::Team.unique.name
    league_name = Faker::GameOfThrones.unique.house

    described_class.run!(
      current_user: user,
      name: league_name,
      fpl_team_name: team_name,
      code: SecureRandom.hex(6)
    )

    form = described_class.run(
      current_user: user,
      name: league_name,
      fpl_team_name: team_name,
      code: SecureRandom.hex(6)
    )

    expect(form.errors.full_messages).to include("Name #{league_name} has already been taken")
    expect(form.errors.full_messages).to include("Fpl team name #{team_name} has already been taken")
  end
end
