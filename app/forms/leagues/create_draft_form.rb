class Leagues::CreateDraftForm
  include ActiveModel::Model
  include ::Virtus.model

  attr_accessor :league

  def initialize(league:, current_user:)
    @league = league
    @current_user = current_user
  end

  validate :user_is_commissioner
  validate :minimum_required_users
  validate :draft_already_initiated

  MIN_FPL_TEAM_NUMBER = 8
  PICKS_PER_TEAM = 15

  def save
    return false unless valid?
    ActiveRecord::Base.transaction do
      player_arr = @league.fpl_teams.shuffle
      (player_arr.count * PICKS_PER_TEAM).times do |i|
        DraftPick.create(pick_number: (i + 1), league: league)
      end

      @league.draft_picks.sort.each_slice(player_arr.count) do |batch|
        if batch.last.pick_number % (2 * player_arr.count) == 0
          batch.each_with_index { |pick, i| pick.update(fpl_team: player_arr.reverse[i]) }
        else
          batch.each_with_index { |pick, i| pick.update(fpl_team: player_arr[i]) }
        end
      end
      true
    end
  end

  private

  def user_is_commissioner
    if @league.commissioner != @current_user
      errors.add(:base, 'You are not authorised to initiate the draft')
    end
  end

  def minimum_required_users
    if @league.fpl_teams.count < MIN_FPL_TEAM_NUMBER
      errors.add(:base, "You need at least #{MIN_FPL_TEAM_NUMBER} to initiate the draft")
    end
  end

  def draft_already_initiated
    errors.add(:base, 'The draft has already been initiated') if @league.draft_picks.any?
  end
end
