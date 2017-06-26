class DraftPicksController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!
  before_action :set_league
  # before_action :set_current_draft_pick, only: [:show, :edit, :update, :destroy]

  # GET /draft_picks
  # GET /draft_picks.json
  def index
    league_decorator = LeagueDecorator.new(@league)
    respond_to do |format|
      format.html
      format.json do
        render json: {
          draft_picks: league_decorator.all_draft_picks,
          current_draft_pick: league_decorator.current_draft_pick,
          unpicked_players: league_decorator.unpicked_players,
          picked_players: league_decorator.picked_players,
          fpl_team: current_user.fpl_teams.find_by(league_id: league_decorator.id),
          positions: Position.all
        }
      end
    end
  end

  # GET /draft_picks/1
  # GET /draft_picks/1.json
  def show
  end

  # GET /draft_picks/new
  def new
  end

  # GET /draft_picks/1/edit
  def edit
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
    league_decorator = LeagueDecorator.new(@league)
    form = Leagues::UpdateDraftPickForm.new(
      league: @league,
      player: Player.find_by(id: params[:player_id]),
      current_user: current_user,
      draft_pick: league_decorator.current_draft_pick
    )

    respond_to do |format|
      if form.save
        format.json do
          render json: {
            draft_picks: league_decorator.all_draft_picks,
            current_draft_pick: league_decorator.current_draft_pick,
            fpl_team: current_user.fpl_teams.find_by(league_id: league_decorator.id),
            picked_players: league_decorator.picked_players,
            unpicked_players: league_decorator.unpicked_players,
            positions: Position.all
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

  # DELETE /draft_picks/1
  # DELETE /draft_picks/1.json
  def destroy
    @draft_pick.destroy
    respond_to do |format|
      format.html { redirect_to draft_picks_url, notice: 'Draft pick was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def set_league
      @league = League.find_by(id: params[:league_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def draft_pick_params
      params.fetch(:draft_pick, {})
    end
end
