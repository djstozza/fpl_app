class InterTeamTradeGroups::Base < ApplicationInteraction

  validate :round_is_current

  run_in_transaction!

  private

  def authorised_user_out_fpl_team
    return if out_fpl_team.user == current_user
    errors.add(:base, 'You are not authorised to make changes to this team.')
  end

  def in_fpl_team_in_league
    return if in_fpl_team.league == league
    errors.add(:base, 'Your fpl team is not part of this league.')
  end

  def authorised_user_in_fpl_team
    return if in_fpl_team.user == current_user
    errors.add(:base, 'You are not authorised to make changes to this team.')
  end

  def out_player_in_fpl_team
    return if out_fpl_team.players.include?(out_player)
    errors.add(:base, 'You can only trade out players that are part of your team.')
  end

  def in_player_in_fpl_team
    return if in_fpl_team.players.include?(in_player)
    errors.add(:base, 'You can only propose trades with players that are in that fpl team.')
  end

  def identical_player_and_target_positions
    return if out_player.position == in_player.position
    errors.add(:base, 'You can only trade players that have the same positions.')
  end

  def round_is_current
    return if round.id == Round.current_round.id
    errors.add(:base, "You can only make changes to your squad's line up for the upcoming round.")
  end

  def trade_occurring_in_valid_period
    if Time.now > round.deadline_time
      errors.add(:base, 'The deadline time for making trades this round has passed.')
    end
  end

  def unique_in_player_in_group
    if inter_team_trade_group.inter_team_trades.where(in_player: in_player).present?
      errors.add(:base, "A trade already exists with this  player in the trade group #{in_player.name}.")
    end
  end

  def unique_out_player_in_group
    if inter_team_trade_group.inter_team_trades.where(out_player: out_player).present?
      errors.add(:base, "A trade already exists with this  player in the trade group #{out_player.name}.")
    end
  end

  def valid_team_quota_out_fpl_team
    player_arr = out_fpl_team.players.to_a.delete_if { |player| player == out_player }
    team_arr = player_arr.map { |player| player.team_id }
    team_arr << in_player.team_id
    return if team_arr.count(in_player.team_id) <= FplTeam::QUOTAS[:team]
    errors.add(
      :base,
      "You can't have more than #{FplTeam::QUOTAS[:team]} players from the same team (#{in_player.team.name})."
    )
  end

  def valid_team_quota_in_fpl_team
    player_arr = in_fpl_team.players.to_a.delete_if { |player| player == in_player }
    team_arr = player_arr.map { |player| player.team_id }
    team_arr << out_player.team_id
    return if team_arr.count(in_player.team_id) <= FplTeam::QUOTAS[:team]
    errors.add(
      :base,
      "#{in_fpl_team.name} can't have more than #{FplTeam::QUOTAS[:team]} players from the same team " \
        "(#{out_player.team.name})."
    )
  end

  def inter_team_trade_group_pending
    return if inter_team_trade_group.pending?
    errors.add(:base, 'You cannot add more picks to this trade proposal as it is no longer pending.')
  end

  def inter_team_trade_group_unprocessed
    return if inter_team_trade_group.submitted? || inter_team_trade_group.pending?
    errors.add(:base, 'You cannot add more picks to this trade proposal as it has already been processed.')
  end

  def inter_team_trade_group_pending
    return if inter_team_trade_group.pending?
    errors.add(:base, 'You cannot add more picks to this trade proposal as it is no longer pending.')
  end

  def out_players_in_fpl_team
    remainder = inter_team_trade_group.out_players - out_fpl_team.players
    return if remainder.empty?
    errors.add(:base, "Not all proposed trades are in the fpl_team.")
  end

  def in_players_in_fpl_team
    remainder = inter_team_trade_group.in_players - in_fpl_team.players
    return if remainder.empty?
    errors.add(:base, "Not all proposed trades are in the fpl_team.")
  end

  def round_deadline_time_passed
    return if Time.now < round.deadline_time
    errors.add(:base, "Trades can still occur as the round's deadline time hasn't passed.")
  end
end
