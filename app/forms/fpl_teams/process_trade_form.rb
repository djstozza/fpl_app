class FplTeams::ProcessTradeForm < ApplicationInteraction
  object :current_user, class: User
  object :fpl_team, class: FplTeam
  object :list_position, class: ListPosition
  object :round, class: Round, default: -> { list_position.fpl_team_list.round }
  object :league, class: League, default: -> { fpl_team.league }
  object :out_player, class: Player, default: -> { list_position.player }
  object :in_player, class: Player

  validate :authorised_user
  validate :player_in_fpl_team
  validate :target_unpicked
  validate :round_is_current
  validate :trade_occurring_in_valid_period
  validate :identical_player_and_target_positions
  validate :maximum_number_of_players_from_team

  run_in_transaction!

  def execute
    fpl_team.players.delete(out_player)
    fpl_team.players << in_player
    league.players.delete(out_player)
    league.players << in_player
    list_position.update!(player: in_player)
  end

  private

  def authorised_user
    return if fpl_team.user == current_user
    errors.add(:base, 'You are not authorised to make changes to this team.')
  end

  def player_in_fpl_team
    return if fpl_team.players.include?(out_player)
    errors.add(:base, 'You can only trade out players that are part of your team.')
  end

  def target_unpicked
    return unless in_player.leagues.include?(league)
    errors.add(:base, 'The player you are trying to trade into your team is owned by another team in your league.')
  end

  def trade_occurring_in_valid_period
    if Time.now < round.deadline_time - 1.day && round.id != Round.first.id
      errors.add(:base, 'You cannot trade players until the waiver cutoff time has passed.')
    elsif Time.now > round.deadline_time
      errors.add(:base, 'The deadline time for making trades has passed.')
    end
  end

  def identical_player_and_target_positions
    return if out_player.position == in_player.position
    errors.add(:base, 'You can only trade players that have the same positions.')
  end

  def round_is_current
    return if round.id == Round.current_round.id
    errors.add(:base, "You can only make changes to your squad's line up for the upcoming round.")
  end

  def maximum_number_of_players_from_team
    player_arr = fpl_team.players.to_a.delete_if { |player| player == out_player }
    team_arr = player_arr.map { |player| player.team_id }
    team_arr << in_player.team_id
    return if team_arr.count(in_player.team_id) <= FplTeam::QUOTAS[:team]
    errors.add(
      :base,
      "You can't have more than #{FplTeam::QUOTAS[:team]} players from the same team (#{in_player.team.name})."
    )
  end
end
