class FplTeams::EditForm < ApplicationInteraction
  object :current_user, class: User
  object :fpl_team, class: FplTeam

  model_fields :fpl_team do
    string :name
  end

  validate :fpl_team_name_uniqueness
  validate :authorised_user

  def execute
    fpl_team.assign_attributes(name: name)
    fpl_team.save
    errors.merge!(fpl_team.errors)
  end

  def to_model
    fpl_team
  end

  private

  def fpl_team_name_uniqueness
    return unless FplTeam.where('lower(name) = ?', name.downcase).count.positive?
    errors.add(:fpl_team_name, 'has already been taken.')
  end

  def authorised_user
    return if fpl_team.user = current_user
    errors.add(:base, 'You are not authorised to edit this fpl team.')
  end
end
