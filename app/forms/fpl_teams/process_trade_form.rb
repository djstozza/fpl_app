class FplTeams::ProcessTradeForm
  include ActiveModel::Model
  include Virtus.model

  attr_accessor :fpl_team, :list_position, :current_user

  def initialize(fpl_team:, list_position:, target:, current_user:)
    @list_position = list_position
    @fpl_team = fpl_team
    @player = list_position.player
    @target = target
    @league = fpl_team.league
    @round = list_position.fpl_team_list.round
    @current_user = current_user
  end

  validate :authorised_user
  validate :player_in_fpl_team
  validate :target_unpicked
  validate :trade_occurring_in_valid_period
  validate :identical_player_and_target_positions
  validate :maximum_number_of_players_from_team

  QUOTAS = {
    team: 3
  }.freeze

  def save
    return false unless valid?

    ActiveRecord::Base.transaction do
      @fpl_team.players.delete(@player)
      @fpl_team.players << @target
      @league.players.delete(@player)
      @league.players << @target
      @list_position.update!(player: @target)
      true
    end
  end

  private

  def authorised_user
    return if @fpl_team.user == @current_user
    errors.add(:base, 'You are not authorised to make changes to this team.')
  end

  def player_in_fpl_team
    return if @fpl_team.players.include?(@player)
    errors.add(:base, 'You can only trade out players that are part of your team.')
  end

  def target_unpicked
    return unless @target.leagues.include?(@league)
    errors.add(:base, 'The player you are trying to trade into your team is owned by another team in your league.')
  end

  def trade_occurring_in_valid_period
    if Time.now < @round.deadline_time - 1.day
      errors.add(:base, 'You cannot trade players until the waiver cutoff time has passed.')
    elsif Time.now > @round.deadline_time
      errors.add(:base, 'The deadline time for making trades has passed.')
    end
  end

  def identical_player_and_target_positions
    return if @player.position == @target.position
    errors.add(:base, 'You can only trade players that have the same positions.')
  end

  def maximum_number_of_players_from_team
    player_arr = @fpl_team.players.to_a.delete_if { |player| player == @player }
    team_arr = player_arr.map { |player| player.team_id }
    team_arr << @target.team_id
    return if team_arr.count(@target.team_id) <= QUOTAS[:team]
    errors.add(:base, "You can't have more than #{QUOTAS[:team]} players from the same team (#{@target.team.name}).")
  end
end
