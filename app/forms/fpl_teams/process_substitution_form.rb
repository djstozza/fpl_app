class FplTeams::ProcessSubstitutionForm
  include ActiveModel::Model
  include Virtus.model

  attr_accessor :fpl_team_list, :current_user

  def initialize(fpl_team_list:, player:, target:, current_user:)
    @fpl_team_list = fpl_team_list
    @player = player
    @target = target
    @player_position = fpl_team_list.list_positions.find_by(player: @player)
    @target_position = fpl_team_list.list_positions.find_by(player: @target)
    @current_user = current_user
    @round = fpl_team_list.round
  end

  validate :round_is_current
  validate :before_deadline_time
  validate :authorised_user
  validate :player_team_presnece
  validate :target_team_presence
  validate :valid_starting_line_up

  def save
    return false unless valid?

    ActiveRecord::Base.transaction do
      @player_position.update!(player: @target, position: @target.position)
      @target_position.update!(player: @player, position: @player.position)
      true
    end
  end

  private

  def round_is_current
    return if @round.id == RoundsDecorator.new(Round.all).current_round.id
    errors.add(:base, "You can only make changes to your squad's line up for the upcoming round.")
  end

  def before_deadline_time
    return if Time.now < @round.deadline_time
    errors.add(:base, 'The deadline time for making substitutions has passed.')
  end

  def authorised_user
    return if @fpl_team_list.fpl_team.user == @current_user
    errors.add(:base, 'You are not authorised to make changes to this team.')
  end

  def player_team_presnece
    errors.add(:base, "#{@player.name} isn't part of your team.") if @player_position.blank?
  end

  def target_team_presence
    errors.add(:base, "#{@target.name} isn't part of your team.") if @target_position.blank?
  end

  def valid_starting_line_up
    @starting_lineup_arr = @fpl_team_list.list_positions.starting.to_a
    if @player_position.starting? && @target_position.starting?
      errors.add(:base, 'You cannot substitute starting players')
    elsif @player_position.starting? && !@target_position.starting?
      @starting_lineup_arr.delete_if { |list_position| list_position == @player_position }
      @starting_lineup_arr << @target_position
    elsif @target_position.starting? && !@player_position.starting?
      @starting_lineup_arr.delete_if { |list_position| list_position == @target_position }
      @starting_lineup_arr << @player_position
    end

    if starting_position_count('Forward').zero?
      errors.add(:base, 'There must be at least one forward in the starting line up.')
    end

    if starting_position_count('Midfielder') < 2
      errors.add(:base, 'There must be at least two midfielders in the starting line up.')
    end

    if starting_position_count('Defender') < 3
      errors.add(:base, 'There must be at least three defenders in the starting line up.')
    end

    if starting_position_count('Goalkeeper') != 1
      errors.add(:base, 'There must be one goalkeeper in the starting line up.')
    end
  end

  def starting_position_count(position_name)
    @starting_lineup_arr.select { |list_position| list_position.position.singular_name == position_name }.count
  end
end
