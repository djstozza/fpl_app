class MiniDraftPicksController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!
  before_action :set_league
  respond_to :json, except: :index

  # GET leagues/1/mini_draft_picks
  # GET leagues/1/mini_draft_picks.json
  def index
    league_decorator = LeagueMiniDraftPicksDecorator.new(@league)
    fpl_team = FplTeamDecorator.new(current_user.fpl_teams.find_by(league_id: league_decorator.id))
    respond_to do |format|
      format.html
      format.json do
        render json: {
          draft_picks: league_decorator.all_non_passed_draft_picks,
          current_draft_pick: league_decorator.current_draft_pick,
          unpicked_players: league_decorator.unpicked_players,
          current_user: current_user,
          fpl_team: fpl_team,
          line_up: fpl_team.current_line_up,
          fpl_team_list: fpl_team.current_fpl_team_list,
          round: Round.current_round,
          status: Round.round_status,
          positions: Position.all
        }
      end
    end
  end


  # POST leagues/1/mini_draft_picks
  # POST leagues/1/mini_draft_picks.json
  def create
    form = ::Leagues::ProcessMiniDraftPickForm.run(params.merge(current_user: current_user))
    league_decorator = LeagueMiniDraftPicksDecorator.new(@league)
    fpl_team = FplTeamDecorator.new(current_user.fpl_teams.find_by(league_id: league_decorator.id))
    round = Round.current_round
    status = Round.round_status
    fpl_team_list = FplTeamList.find_by(id: params[:fpl_team_list_id])


    if form.valid?
      render json: {
        league: league_decorator,
        draft_picks: league_decorator.all_non_passed_draft_picks,
        line_up: fpl_team.current_line_up,
        current_draft_pick: league_decorator.current_draft_pick,
        unpicked_players: league_decorator.unpicked_players,
        picked_players: league_decorator.picked_players,
        current_user: current_user,
        fpl_team: fpl_team,
        fpl_team_list: fpl_team_list,
        round: round,
        status: status,
        success: "You have successfully traded out #{form.out_player.name} for #{form.in_player.name} in the " \
                 "mini draft."
      }
    else
      render json: {
          errors: form.errors.full_messages,
          draft_picks: league_decorator.all_non_passed_draft_picks,
          current_draft_pick:  league_decorator.current_draft_pick,
          fpl_team: fpl_team,
          fpl_team_list: fpl_team_list,
          league: league_decorator,
          line_up: fpl_team.current_line_up,
          picked_players: league_decorator.picked_players,
          unpicked_players: league_decorator.unpicked_players,
          current_user: current_user,
          round: round,
          status: status
        }, status: :unprocessable_entity
    end
  end

  private

  def set_league
    @league = League.find(params[:league_id])
  end
end
