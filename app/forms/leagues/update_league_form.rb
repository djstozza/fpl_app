class Leagues::UpdateLeagueForm < ApplicationInteraction
  object :league, class: League
  object :current_user, class: User
  string :league_name
  string :code

  validate :league_name_uniqueness
  validate :user_is_commissioner

  def execute
    league.assign_attributes(name: league_name, code: code)
    league.save
  end

  private

  def user_is_commissioner
    if league&.commissioner && league.commissioner != current_user
      errors.add(:base, 'You are not authorised to make changes to this league')
    end
  end

  def league_name_uniqueness
    return if league_name.blank?
    return if league_name.downcase == league&.name&.downcase
    if League.where('lower(name) = ?', league_name.downcase).count.positive?
      errors.add(:base, 'League name has already been taken')
    end
  end
end
