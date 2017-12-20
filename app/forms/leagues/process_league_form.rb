class Leagues::ProcessLeagueForm < ApplicationInteraction
  object :current_user, class: User
  object :league, class: League
  string :league_name
  string :code

  validates :league_name, :code, presence: true
  validate :league_name_uniqueness
  validate :user_is_commissioner

  run_in_transaction!

  def execute
    league.assign_attributes(name: league_name, code: code, commissioner: current_user)
    league.save
    errors.merge!(league.errors)
  end

  def to_model
    league
  end

  private

  def league_name_uniqueness
    return if league_name == league.name
    if League.where('lower(name) = ?', league_name.downcase).count.positive?
      errors.add(:league_name, "(#{league_name}) has already been taken.")
    end
  end

  def user_is_commissioner
    return if league.commissioner = current_user
    errors.add(:base, 'You are not authorised to edit this league.')
  end
end
