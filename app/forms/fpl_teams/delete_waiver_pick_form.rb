class FplTeams::DeleteWaiverPickForm
  include ActiveModel::Model
  include Virtus.model

  attr_accessor :waiver_pick, :fpl_team

  def initialize(fpl_team:, waiver_pick:, current_user:)
    @fpl_team = fpl_team
    @waiver_pick = waiver_pick
    @round = waiver_pick.round
    @waiver_picks = fpl_team.waiver_picks.where(round_id: @round.id)
    @current_user = current_user
  end

  validate :authorised_user
  validate :pending_waiver_pick
  validate :fpl_team_waiver_pick
  validate :round_is_current
  validate :waiver_pick_deletion_occurring_in_valid_period

  def save
    return false unless valid?

    ActiveRecord::Base.transaction do
      @waiver_picks.where('pick_number > ?', @waiver_pick.pick_number).each do |waiver_pick|
        waiver_pick.update!(pick_number: waiver_pick.pick_number - 1)
      end
      @waiver_pick.destroy
    end
    true
  end

  private

  def authorised_user
    return if @fpl_team.user == @current_user
    errors.add(:base, 'You are not authorised to make changes to this team.')
  end

  def pending_waiver_pick
    return if @waiver_pick.pending?
    errors.add(:base, 'You can only delete pending waiver picks.')
  end

  def fpl_team_waiver_pick
    return if @fpl_team.waiver_picks.include?(@waiver_pick)
    errors.add(:base, 'This waiver pick does not belong to your team.')
  end

  def round_is_current
    return if @round.id == RoundsDecorator.new(Round.all).current_round.id
    errors.add(:base, "You can only make changes to your squad's line up for the upcoming round.")
  end

  def waiver_pick_deletion_occurring_in_valid_period
    if Time.now > @round.deadline_time - 2.days
      errors.add(:base, 'The deadline time for updating waiver picks this round has passed.')
    end
  end
end
