require 'rails_helper'

RSpec.describe Leagues::UpdateLeagueForm, type: :form do
  it 'successfully updates the league' do
    user = FactoryBot.build_stubbed(:user)
    league = FactoryBot.build_stubbed(:league, commissioner: user)
    expect(league).to receive(:save)

    form = described_class.run(
      league: league,
      current_user: user,
      league_name: Faker::GameOfThrones.house,
      code: SecureRandom.hex(6)
    )

    expect(league.name).to eq(form.league_name)
    expect(league.code).to eq(form.code)
  end

  it 'does not allow a user to edit the league if the user is not the commissioner' do
    user = FactoryBot.build_stubbed(:user)
    league = FactoryBot.build_stubbed(:league, commissioner: user)
    form = described_class.run(
      league: league,
      current_user: FactoryBot.build_stubbed(:user),
      league_name: Faker::GameOfThrones.house,
      code: SecureRandom.hex(6)
    )

    expect(form.errors.full_messages).to include('You are not authorised to make changes to this league')
  end
end
