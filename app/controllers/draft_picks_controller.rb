class DraftPicksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_league
  before_action :set_draft_pick, only: [:show, :edit, :update, :destroy]

  # GET /draft_picks
  # GET /draft_picks.json
  def index
    respond_to do |format|
      format.json { render json: @league.draft_picks }
    end
  end

  # GET /draft_picks/1
  # GET /draft_picks/1.json
  def show
  end

  # GET /draft_picks/new
  def new
    form = Leagues::CreateDraftForm.new(league: @league, current_user: current_user)
    respond_to do |format|
      if form.save
        format.json { render json: @league.draft_picks }
      else
        format.json { render json: form.errors, status: :unprocessable_entity }
      end
    end
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
        format.json { render json: @league.draft_picks }
      else
        format.json { render json: form.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /draft_picks/1
  # PATCH/PUT /draft_picks/1.json
  def update
    respond_to do |format|
      if @draft_pick.update(draft_pick_params)
        format.html { redirect_to @draft_pick, notice: 'Draft pick was successfully updated.' }
        format.json { render :show, status: :ok, location: @draft_pick }
      else
        format.html { render :edit }
        format.json { render json: @draft_pick.errors, status: :unprocessable_entity }
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
    # Use callbacks to share common setup or constraints between actions.
    def set_draft_pick
      @draft_pick = DraftPick.find(params[:id])
    end

    def set_league
      @league = League.find_by(id: params[:league_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def draft_pick_params
      params.fetch(:draft_pick, {})
    end
end
