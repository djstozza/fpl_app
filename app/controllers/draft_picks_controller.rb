class DraftPicksController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!
  before_action :set_league

  # GET /draft_picks
  # GET /draft_picks.json
  def index
    league_decorator = LeagueDraftPicksDecorator.new(@league)
    respond_to do |format|
      format.html
      format.json do
        render json: {
          draft_picks: league_decorator.all_draft_picks,
          current_draft_pick: league_decorator.current_draft_pick,
          unpicked_players: league_decorator.unpicked_players,
          fpl_team: current_user.fpl_teams.find_by(league_id: league_decorator.id),
          positions: Position.all
        }
      end
    end
  end

  # POST /draft_picks
  # POST /draft_picks.json
  def create
    form = Leagues::CreateDraftForm.new(league: @league, current_user: current_user)
    respond_to do |format|
      if form.save
        format.json { render json: { draft_picks: @league.draft_picks } }
      else
        format.json { render json: form.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /draft_picks/1
  # PATCH/PUT /draft_picks/1.json
  def update
    league_decorator = LeagueDraftPicksDecorator.new(@league)
    form = Leagues::UpdateDraftPickForm.run(
      league: @league,
      player: Player.find_by(id: params[:player_id]),
      current_user: current_user,
      draft_pick: league_decorator.current_draft_pick
    )

    respond_to do |format|
      if form.valid?
        format.json do
          render json: {
            draft_picks: league_decorator.all_draft_picks,
            current_draft_pick: league_decorator.current_draft_pick,
            fpl_team: current_user.fpl_teams.find_by(league_id: league_decorator.id),
            picked_players: league_decorator.picked_players,
            unpicked_players: league_decorator.unpicked_players,
            positions: Position.all,
            success: "You have successfully drafted #{form.player.name}.",
          }
        end
      else
        format.json do
          render json: {
            errors: form.errors.full_messages,
            draft_picks: league_decorator.all_draft_picks,
            current_draft_pick:  league_decorator.current_draft_pick,
            fpl_team: current_user.fpl_teams.find_by(league_id: league_decorator.id),
            picked_players: league_decorator.picked_players,
            unpicked_players: league_decorator.unpicked_players,
            positions: Position.all
          }, status: :unprocessable_entity
        end
      end
    end
  end

  private

  def set_league
    @league = League.find_by(id: params[:league_id])
  end
end
