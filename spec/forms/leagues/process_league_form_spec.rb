require 'rails_helper'

RSpec.describe Leagues::ProcessLeagueForm, type: :form do
  let(:user) { FactoryGirl.create(:user) }
  let(:form_attributes) do
    { league_name: Faker::GameOfThrones.house, code: SecureRandom.hex(6), fpl_team_name: Faker::Team.name }
  end

  context '#save' do
    it 'successfully creates a league and fpl team' do
      form = Leagues::ProcessLeagueForm.new(league: League.new, current_user: user, fpl_team: FplTeam.new)
      form.attributes = form_attributes
      form.save
      expect(League.first.name).to eq(form.league.name)
      expect(League.first.code).to eq(form.league.code)
      expect(League.first.commissioner).to eq(user)
      expect(FplTeam.first).to eq(form.fpl_team)
      expect(FplTeam.first.league).to eq(League.first)
      expect(FplTeam.first.user).to eq(user)
    end

    it 'requires a league name' do
      invalid_record(attribute: :league_name, method: 'save', message: "can't be blank")
    end

    it 'requires a fpl team name' do
      invalid_record(attribute: :fpl_team_name, method: 'save', message: "can't be blank")
    end

    it 'requires a code' do
      invalid_record(attribute: :code, method: 'save', message: "can't be blank")
    end

    it 'requires a unique league name' do
      league = FactoryGirl.create(:league, commissioner: FactoryGirl.create(:user))
      invalid_record(attribute: :league_name, value: league.name, method: 'save', message: 'has already been taken')
    end

    it 'requires a unique fpl team name' do
      league = FactoryGirl.create(:league, commissioner: FactoryGirl.create(:user))
      fpl_team = FactoryGirl.create(:fpl_team, user: FactoryGirl.create(:user), league: league)
      invalid_record(attribute: :fpl_team_name, value: fpl_team.name, method: 'save', message: 'has already been taken')
    end
  end

  context 'update' do
    before do
      @league = FactoryGirl.create(:league, commissioner: user)
      @fpl_team = FactoryGirl.create(:fpl_team, user: user, league: @league)
      @league_name = @league.name
      @league_code = @league.code
      @fpl_team_name = @fpl_team.name
    end

    it 'successfully updates the league' do
      form = Leagues::ProcessLeagueForm.new(league: @league, current_user: user, fpl_team: @fpl_team)
      form.attributes = form_attributes
      form.update
      expect(form.league.name).not_to eq(@league_name)
      expect(form.league.code).not_to eq(@league_code)
      expect(form.fpl_team.name).not_to eq(@fpl_team_name)
    end

    it 'requires a league name' do
      invalid_record(attribute: :league, method: 'update', message: "can't be blank")
    end

    it 'requires an fpl team name' do
      invalid_record(attribute: :fpl_team, method: 'update', message: "can't be blank")
    end

    it 'does not update if the user is not the commissioner' do
      @user = FactoryGirl.create(:user)
      invalid_record(method: 'update', message: 'You are not authorised to make changes to this league')
    end

    it 'requires a unique league name' do
      league_1 = FactoryGirl.create(:league, commissioner: user)
      form = Leagues::ProcessLeagueForm.new(league: @league, current_user: user, fpl_team: @fpl_team)
      form_attributes[:league_name] = league_1.name
      form.attributes = form_attributes
      form.update
      expect(form.valid?).to be_falsey
      expect(form.errors.full_messages).to include('League name has already been taken')
    end

    it 'requires a unique fpl team name' do
      fpl_team_1 = FactoryGirl.create(:fpl_team, user: FactoryGirl.create(:user), league: @league)
      form = Leagues::ProcessLeagueForm.new(league: @league, current_user: user, fpl_team: @fpl_team)
      form_attributes[:fpl_team_name] = fpl_team_1.name
      form.attributes = form_attributes
      form.update
      expect(form.valid?).to be_falsey
      expect(form.errors.full_messages).to include('Fpl team name has already been taken')
    end
  end

  private

  def invalid_record(attribute: nil, value: nil, method:, message:)
    league = @league || League.new
    fpl_team = @fpl_team || FplTeam.new
    user = @user || user
    form = Leagues::ProcessLeagueForm.new(league: league, current_user: user, fpl_team: fpl_team)
    form_attributes[attribute] = value if attribute.present?
    form.attributes = form_attributes
    form.public_send(method)
    expect(form.valid?).to be_falsey
    message = attribute.present? ? "#{attribute.to_s.humanize} #{message}" : message
    expect(form.errors.full_messages).to include(message)
    expect{ form.public_send(method) }.to_not change(League, :count) if method == 'save'
    expect{ form.public_send(method) }.to_not change(FplTeam, :count) if method == 'save'
  end
end
