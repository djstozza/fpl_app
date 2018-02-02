require 'rails_helper'

RSpec.describe Leagues::UpdateDraftPickForm, type: :form do
  before :each do
    FactoryBot.create(:round, deadline_time: 2.days.from_now)
    10.times do |i|
      i += 1
      user = FactoryBot.create(:user, username: "#{Faker::Name.first_name} #{i}")
      FactoryBot.create(:league, commissioner: User.first) if i == 1
      FactoryBot.create(:fpl_team, name: "#{Faker::Team.name} #{i}", user: user, league: League.first)
    end
    20.times do
      FactoryBot.create(:team)
    end
    1000.times do
      FactoryBot.create(:player, team: Team.all.sample, position: Position.all.sample)
    end
    Leagues::CreateDraftForm.new(league: League.first, current_user: League.first.commissioner).save
  end

  it 'successfully picks a player' do
    form = described_class.run(
      league: League.first,
      draft_pick: selected_pick(1),
      player: Player.first,
      current_user: selected_pick(1).fpl_team.user
    )
    expect(form.fpl_team.players.first).to eq(Player.first)
    expect(form.league.players.first).to eq(Player.first)
  end

  it 'fails to complete the pick if the player has already been picked.' do
    described_class.run!(
      league: League.first,
      draft_pick: selected_pick(1),
      player: Player.first,
      current_user: selected_pick(1).fpl_team.user
    )

    form = described_class.run(
      league: League.first,
      draft_pick: selected_pick(2),
      player: Player.first,
      current_user: selected_pick(2).fpl_team.user
    )

    expect(form.errors.full_messages).to include('This player has already been picked.')
    expect(selected_pick(1).fpl_team.players).to include(Player.first)
    expect(selected_pick(2).fpl_team.players).to be_empty
    expect(form.league.players.count).to eq(1)
  end

  it 'fails to complete the pick the fpl team does not correspond to the pick' do
    form = described_class.run(
      league: League.first,
      draft_pick: selected_pick(1),
      player: Player.first,
      current_user: selected_pick(2).fpl_team.user
    )

    expect(form.errors.full_messages).to include('You cannot pick out of turn.')
    expect(form.fpl_team.players).to be_empty
    expect(form.draft_pick.fpl_team.players).to be_empty
    expect(form.league.players).to be_empty
  end

  it 'fails to complete the pick if the draft pick occurs out of turn' do
    form = Leagues::UpdateDraftPickForm.run(
      league: League.first,
      draft_pick: selected_pick(2),
      player: Player.first,
      current_user: selected_pick(2).fpl_team.user
    )

    expect(form.errors.full_messages).to include('You cannot pick out of turn.')
    expect(form.fpl_team.players).to be_empty
    expect(form.draft_pick.fpl_team.players).to be_empty
    expect(form.league.players).to be_empty
  end

  it 'fails to pick more than the position quota or team quota' do
    goalkeepers = Position.find_by(plural_name: 'Goalkeepers')
    10.times do |i|
      j = i + 1
      described_class.run!(
        league: League.first,
        draft_pick: selected_pick(j),
        player: goalkeepers.players.where(team: Team.all[i]).first,
        current_user: selected_pick(j).fpl_team.user
      )
    end

    10.times do |i|
      j = 9 - i
      n = i + 11
      described_class.run!(
        league: League.first,
        draft_pick: selected_pick(n),
        player: goalkeepers.players.where(team: Team.all[j]).second,
        current_user: selected_pick(n).fpl_team.user
      )
    end

    form = described_class.run(
      league: League.first,
      draft_pick: selected_pick(21),
      player: goalkeepers.players.where(team: Team.first).third,
      current_user: selected_pick(21).fpl_team.user
    )

    expect(form.errors.full_messages).to include("You can't have more than 2 Goalkeepers in your team.")

    10.times do |i|
      expect(FplTeam.all[i].players.where(position: goalkeepers).count).to eq(2)
    end

    forwards = Position.find_by(plural_name: 'Forwards')
    10.times do |i|
      n = i + 21
      described_class.run!(
        league: League.first,
        draft_pick: selected_pick(n),
        player: forwards.players.where(team: Team.all[i]).first,
        current_user: selected_pick(n).fpl_team.user
      )
    end

    form = described_class.run(
      league: League.first,
      draft_pick: selected_pick(31),
      player: forwards.players.where(team: Team.all[9]).second,
      current_user: selected_pick(31).fpl_team.user
    )

    expect(form.errors.full_messages).to include(
      "You can't have more than #{FplTeam::QUOTAS[:team]} players from the same team " \
        "(#{form.player.team.name})."
    )
  end

  private

  def selected_pick(pick)
    League.first.draft_picks.find_by(pick_number: pick)
  end
end
