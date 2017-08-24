class FplTeams::CreateWaiverPickForm
  include ActiveModel::Model
  include Virtus.model

  attr_accessor :fpl_team_list, :current_user

  def initialize(fpl_team_list:, list_position:, in_player:, current_user:)
    @fpl_team_list = fpl_team_list
    @fpl_team = fpl_team_list.fpl_team
    @out_player = list_position.player
    @in_player = in_player
    @league = @fpl_team.league
    @round = fpl_team_list.round
    @waiver_picks = fpl_team_list.waiver_picks
    @current_user = current_user
  end

  validate :authorised_user
  validate :player_in_fpl_team
  validate :target_unpicked
  validate :round_is_current
  validate :not_first_round
  validate :waiver_pick_occurring_in_valid_period
  validate :identical_player_and_target_positions
  validate :maximum_number_of_players_from_team
  validate :duplicate_waiver_picks

  QUOTAS = {
    team: 3
  }.freeze

  def save
    return false unless valid?

    ActiveRecord::Base.transaction do
      WaiverPick.create!(
        fpl_team_list: @fpl_team_list,
        out_player: @out_player,
        in_player: @in_player,
        round_id: @round.id,
        league: @league,
        pick_number: @fpl_team_list.waiver_picks.count + 1
      )
    end

    true
  end

  private

  def authorised_user
    return if @fpl_team.user == @current_user
    errors.add(:base, 'You are not authorised to make changes to this team.')
  end

  def player_in_fpl_team
    return if @fpl_team.players.include?(@out_player)
    errors.add(:base, 'You can only trade out players that are part of your team.')
  end

  def target_unpicked
    return unless @in_player.leagues.include?(@league)
    errors.add(:base, 'The player you are trying to trade into your team is owned by another team in your league.')
  end

  def waiver_pick_occurring_in_valid_period
    if Time.now > @round.deadline_time - 1.day
      errors.add(:base, 'The deadline time for making waiver picks this round has passed.')
    end
  end

  def round_is_current
    return if @round.id == RoundsDecorator.new(Round.all).current_round.id
    errors.add(:base, "You can only make changes to your squad's line up for the upcoming round.")
  end

  def not_first_round
    return if @round.id != Round.first.id
    errors.add(:base, 'There are no waiver picks during the first round.')
  end

  def identical_player_and_target_positions
    return if @out_player.position == @in_player.position
    errors.add(:base, 'You can only trade players that have the same positions.')
  end

  def maximum_number_of_players_from_team
    player_arr = @fpl_team.players.to_a.delete_if { |player| player == @out_player }
    team_arr = player_arr.map { |player| player.team_id }
    team_arr << @in_player.team_id
    return if team_arr.count(@in_player.team_id) <= QUOTAS[:team]
    errors.add(
      :base,
      "You can't have more than #{QUOTAS[:team]} players from the same team (#{@in_player.team.name})."
    )
  end

  def duplicate_waiver_picks
    existing_waiver_pick = @waiver_picks.find_by(in_player: @in_player, out_player: @out_player)
    return if existing_waiver_pick.nil?
    errors.add(
      :base,
      "Duplicate waiver pick - (Pick number: #{existing_waiver_pick.pick_number} " \
        "Out: #{existing_waiver_pick.out_player.last_name} " \
        "In: #{existing_waiver_pick.in_player.last_name})."
    )
  end
end
