require 'rails_helper'

RSpec.describe Leagues::ProcessLeagueForm, type: :form do
  let(:user) { FactoryBot.create(:user) }
  let(:league) { FactoryBot.create(:league, commissioner: user) }

  it 'updates the league' do
    name = 'new name'
    code = SecureRandom.hex
    outcome = described_class.run(
      league_id: league.id,
      name: name,
      code: code,
      current_user: user
    )

    expect(outcome).to be_valid
    expect(outcome.name).to eq(name)
    expect(outcome.code).to eq(code)
  end

  it 'does not update if the league name or code is blank' do
    outcome = described_class.run(
      league_id: league.id,
      name: '',
      code: SecureRandom.hex,
      current_user: user
    )

    expect(outcome.errors.full_messages).to include("Name can't be blank")

    outcome = described_class.run(
      league_id: league.id,
      name: 'new name',
      code: '',
      current_user: user
    )

    expect(outcome.errors.full_messages).to include("Code can't be blank")
  end

  it 'requires a unique league name' do
    league_1 = FactoryBot.create(:league)

    outcome = described_class.run(
      league_id: league.id,
      name: league_1.name,
      code: SecureRandom.hex,
      current_user: user
    )

    expect(outcome.errors.full_messages).to include('Name has already been taken')
  end
end
