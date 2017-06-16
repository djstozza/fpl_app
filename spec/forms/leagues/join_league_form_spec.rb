require 'rails_helper'

RSpec.describe Leagues::JoinLeagueForm, type: :form do
  let(:user) { FactoryGirl.create(:user) }
  let(:league) do
    FactoryGirl.create(
      :league,
      name: Faker::GameOfThrones.name,
      code: SecureRandom.hex,
      commissioner: FactoryGirl.create(:user)
    )
  end
  let(:form_attributes) { { league_name: league.name, code: league.code, fpl_team_name: Faker::Team.name } }

  context '#save' do
    it 'successfully joins a league' do
      form = Leagues::JoinLeagueForm.new(fpl_team: FplTeam.new, current_user: user)
      form.attributes = form_attributes
      expect{ form.save }.to change(FplTeam, :count)
      expect(FplTeam.first).to eq(form.fpl_team)
      expect(FplTeam.first.league).to eq(League.first)
      expect(FplTeam.first.user).to eq(user)
    end

    it 'requires a league name' do
      invalid_record(attribute: :league_name, message: "League name can't be blank")
    end

    it 'requires a code' do
      invalid_record(attribute: :code, message: "Code can't be blank")
    end

    it 'does not join a league and create a team if the league name is incorrect' do
      invalid_record(
        attribute: :league_name,
        value: Faker::Team.name,
        message: 'The league name and/or code you have entered is incorrect'
      )
    end

    it 'does not join a league and create an fpl team if the code is incorrect' do
      invalid_record(
        attribute: :code,
        value: SecureRandom.hex(6),
        message: 'The league name and/or code you have entered is incorrect'
      )
    end

    it 'requires a unique fpl team name' do
      fpl_team = FactoryGirl.create(:fpl_team, user: FactoryGirl.create(:user), league: league)
      invalid_record(attribute: :fpl_team_name, value: fpl_team.name, message: 'Fpl team name has already been taken')
    end

    it 'prevents a user joining a team more than once' do
      fpl_team = FactoryGirl.create(:fpl_team, user: FactoryGirl.create(:user), league: league)
      form = Leagues::JoinLeagueForm.new(fpl_team: FplTeam.new, current_user: fpl_team.user)
      form.attributes = form_attributes
      expect{ form.save }.to_not change(FplTeam, :count)
      expect(form.errors.full_messages).to include('You have already joined this league')
    end

    it 'prevents a user from joining if the fpl team limit has been reached' do
      11.times do
        FactoryGirl.create(:fpl_team, user: FactoryGirl.create(:user), league: league)
      end
      form = Leagues::JoinLeagueForm.new(fpl_team: FplTeam.new, current_user: FactoryGirl.create(:user))
      form.attributes = form_attributes
      expect{ form.save }.to_not change(FplTeam, :count)
      expect(form.errors.full_messages).to include('Limit on fpl teams for this league has already been reached')
    end
  end

  private

  def invalid_record(attribute:, value: nil, message:)
    form = Leagues::JoinLeagueForm.new(fpl_team: FplTeam.new, current_user: user)
    form_attributes[attribute] = value
    form.attributes = form_attributes
    form.save
    expect(form.errors.full_messages).to include(message)
    expect{ form.save }.to_not change(FplTeam, :count)
  end
end
