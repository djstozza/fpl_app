class FplTeams::UpdateWaiverPickOrderForm < ApplicationInteraction
  object :current_user, class: User
  object :fpl_team_list, class: FplTeamList
  object :fpl_team, class: FplTeam
  object :waiver_pick, class: WaiverPick

  object :round, default: -> { fpl_team_list.round }

  array :waiver_picks, default: -> { fpl_team_list.waiver_picks }

  integer :new_pick_number

  validate :authorised_user
  validate :pending_waiver_pick
  validate :fpl_team_list_waiver_pick
  validate :round_is_current
  validate :not_first_round
  validate :waiver_pick_update_occurring_in_valid_period
  validate :valid_pick_number
  validate :change_in_pick_number

  run_in_transaction!

  def execute
    if waiver_pick.pick_number > new_pick_number
      waiver_picks.where(
        'pick_number >= :new_pick_number AND pick_number <= :old_pick_number',
        new_pick_number: new_pick_number,
        old_pick_number: waiver_pick.pick_number
      ).each do |pick|
        pick.update!(pick_number: pick.pick_number + 1)
      end
      waiver_pick.update!(pick_number: new_pick_number)
    elsif waiver_pick.pick_number < new_pick_number
      waiver_picks.where(
        'pick_number <= :new_pick_number AND pick_number >= :old_pick_number',
        new_pick_number: new_pick_number,
        old_pick_number: waiver_pick.pick_number
      ).each do |pick|
        pick.update!(pick_number: pick.pick_number - 1)
      end
      waiver_pick.update!(pick_number: new_pick_number)
    end
  end

  private

  def authorised_user
    return if fpl_team.user == current_user
    errors.add(:base, 'You are not authorised to make changes to this team.')
  end

  def fpl_team_list_waiver_pick
    return if fpl_team_list.waiver_picks.include?(waiver_pick)
    errors.add(:base, 'This waiver pick does not belong to your team.')
  end

  def round_is_current
    return if round.id == Round.current_round.id
    errors.add(:base, "You can only make changes to your squad's line up for the upcoming round.")
  end

  def waiver_pick_update_occurring_in_valid_period
    if Time.now > round.deadline_time - 1.days
      errors.add(:base, 'The deadline time for updating waiver picks this round has passed.')
    end
  end

  def pending_waiver_pick
    return if waiver_pick.pending?
    errors.add(:base, 'You can only edit pending waiver picks.')
  end

  def valid_pick_number
    return if waiver_picks.map { |pick| pick.pick_number }.include?(new_pick_number)
    errors.add(:base, 'Pick number is invalid.')
  end

  def change_in_pick_number
    return if waiver_pick.pick_number != new_pick_number
    errors.add(:base, 'No change in pick number.')
  end

  def not_first_round
    return if round.id != Round.first.id
    errors.add(:base, 'There are no waiver picks during the first round.')
  end
end
