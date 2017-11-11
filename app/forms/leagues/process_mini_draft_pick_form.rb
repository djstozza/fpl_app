class Leagues::ProcessMiniDraftPickForm < ApplicationInteraction
  object :league, class: League
  object :league_decorator,
         class: LeagueMiniDraftPicksDecorator,
         default: -> { LeagueMiniDraftPicksDecorator.new(league) }

  object :current_user, class: User

  integer :fpl_team_list_id
  object :fpl_team_list, class: FplTeamList, default: -> { FplTeamList.find(fpl_team_list_id) }
  object :fpl_team, class: FplTeam, default: -> { fpl_team_list.fpl_team }

  integer :player_id
  object :in_player, class: Player, default: -> { Player.find(player_id) }

  integer :list_position_id
  object :list_position, class: ListPosition, default: -> { ListPosition.find(list_position_id) }

  object :out_player, class: Player, default: -> { list_position.player }

  object :round, class: Round, default: -> { fpl_team_list.round }

  string :season, default: -> { league_decorator.season }

  validate :round_is_current
  validate :player_in_fpl_team
  validate :mini_draft_pick_round
  validate :fpl_team_turn
  validate :maximum_number_of_players_from_team
  validate :identical_player_and_target_positions
  validate :target_unpicked
  validate :player_in_fpl_team
  validate :authorised_user
  validate :has_not_passed

  run_in_transaction!

  def execute

    outcome = MiniDraftPick.create(
      fpl_team: fpl_team,
      out_player: out_player,
      in_player: in_player,
      round: round,
      league: league,
      season: league_decorator.season,
      pick_number: league_decorator.next_pick_number
    )
    errors.merge!(outcome.errors) if outcome.errors.any?

    fpl_team_list.list_positions.find_by(player: out_player).update(player: in_player)
    errors.merge!(fpl_team_list.errors)


    league.players.delete(out_player)
    league.players << in_player
    errors.merge!(league.errors)

    fpl_team.players.delete(out_player)
    fpl_team.players << in_player
    errors.merge!(fpl_team.errors)

    if league_decorator.current_draft_pick.fpl_team.mini_draft_picks.public_send(season).where(passed: true).any?
      Leagues::PassMiniDraftPickForm.run(
        league: league,
        fpl_team_list_id: league_decorator.current_draft_pick.fpl_team.fpl_team_lists.find_by(round: round).id,
        current_user: league_decorator.current_draft_pick.fpl_team.user
      )
    end

    ActionCable.server.broadcast("mini_draft_picks_league #{league.id}", {
      draft_picks: league_decorator.all_non_passed_draft_picks,
      current_draft_pick: league_decorator.current_draft_pick,
      unpicked_players: league_decorator.unpicked_players,
      picked_players: league_decorator.picked_players,
      info: "#{current_user.username} has just drafted #{in_player.name} for #{out_player.name} in the mini draft."
    })
  end

  private

  def round_is_current
    return if round.id == Round.current_round.id
    errors.add(:base, "You can only make changes to your squad's line up for the upcoming round.")
  end

  def player_in_fpl_team
    return if fpl_team.players.include?(out_player)
    errors.add(:base, 'You can only trade out players that are part of your team.')
  end

  def mini_draft_pick_round
    return if round.mini_draft
    errors.add(:base, 'Mini draft picks cannot be performed at this time')
  end

  def mini_draft_pick_occurring_in_valid_period
    if Time.now > round.deadline_time
      errors.add(:base, 'The deadline time for making mini draft picks has passed.')
    end
  end

  def fpl_team_turn
    return if league_decorator.next_fpl_team == fpl_team
    errors.add(:base, 'You cannot pick out of turn.')
  end

  def maximum_number_of_players_from_team
    player_arr = fpl_team.players.to_a.delete_if { |player| player == out_player }
    team_arr = player_arr.map(&:team_id)
    team_arr << in_player.team_id
    return if team_arr.count(in_player.team_id) <= FplTeam::QUOTAS[:team]
    errors.add(
      :base,
      "You can't have more than #{FplTeam::QUOTAS[:team]} players from the same team (#{in_player.team.name})."
    )
  end

  def identical_player_and_target_positions
    return if out_player.position == in_player.position
    errors.add(:base, 'You can only trade players that have the same positions.')
  end

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

  def has_not_passed
    return if fpl_team.mini_draft_picks.public_send(season).where(passed: true).blank?
    errors.add(:base, 'You have already passed and will not be able to make any more mini draft picks.')
  end
end
