class Leagues::PassMiniDraftPickForm < ApplicationInteraction
  object :league, class: League
  object :league_decorator,
         class: LeagueMiniDraftPicksDecorator,
         default: -> { LeagueMiniDraftPicksDecorator.new(league) }

  object :current_user, class: User

  integer :fpl_team_list_id
  object :fpl_team_list, class: FplTeamList, default: -> { FplTeamList.find(fpl_team_list_id) }
  object :fpl_team, class: FplTeam, default: -> { fpl_team_list.fpl_team }

  object :round, class: Round, default: -> { fpl_team_list.round }

  string :season, default: -> { league_decorator.season }

  validate :round_is_current
  validate :fpl_team_turn
  validate :authorised_user

  def execute
    outcome = MiniDraftPick.create(
      fpl_team: fpl_team,
      round: round,
      league: league,
      season: league_decorator.season,
      pick_number: league_decorator.next_pick_number,
      passed: true
    )
    errors.merge!(outcome.errors) if outcome.errors.any?

    ActionCable.server.broadcast("mini_draft_picks_league #{league.id}", {
      draft_picks: league_decorator.all_non_passed_draft_picks,
      current_draft_pick: league_decorator.current_draft_pick,
      unpicked_players: league_decorator.unpicked_players,
      picked_players: league_decorator.picked_players,
      info: "#{current_user.username} has passed and can no longer make mini draft picks this round."
    })

    if league_decorator.next_fpl_team&.mini_draft_picks&.public_send(season)&.where(passed: true)&.any?
      self.class.run(
        league: league,
        fpl_team_list_id: league_decorator.current_draft_pick.fpl_team.fpl_team_lists.find_by(round: round).id,
        current_user: league_decorator.current_draft_pick.fpl_team.user
      )
    end
  end

  private

  def round_is_current
    return if round.id == Round.current_round.id
    errors.add(:base, "You can only make changes to your squad's line up for the upcoming round.")
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

  def authorised_user
    return if fpl_team.user == current_user
    errors.add(:base, 'You are not authorised to make changes to this team.')
  end
end
