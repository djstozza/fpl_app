class TradesController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token
  before_action :set_fpl_team, only: [:create]

  # GET /trades
  # GET /trades.json
  def index
    @trades = Trade.all
  end

  # GET /trades/1
  # GET /trades/1.json
  def show
  end

  # GET /trades/new
  def new
    @trade = Trade.new
  end

  # GET /trades/1/edit
  def edit
  end

  # POST /trades
  # POST /trades.json
  def create
    list_position = ListPosition.find_by(id: params[:list_position_id])
    target = Player.find_by(id: params[:target_id])
    form = ::FplTeams::ProcessTradeForm.new(
      fpl_team: @fpl_team,
      list_position: list_position,
      target: target,
      current_user: current_user
    )
    respond_to do |format|
      if form.save
        league_decorator = LeagueDecorator.new(@fpl_team.league)
        format.json do
          render json: {
            line_up: ListPositionsDecorator.new(@fpl_team.fpl_team_lists.first.list_positions).list_position_arr,
            players: @fpl_team.players,
            unpicked_players: league_decorator.unpicked_players,
            picked_players: league_decorator.picked_players,
            success: "You have successfully traded out #{list_position.player.name} for #{target.name}"
          }
        end
      else
        format.json { render json: form.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /trades/1
  # PATCH/PUT /trades/1.json
  def update
    respond_to do |format|
      if @trade.update(trade_params)
        format.html { redirect_to @trade, notice: 'Trade was successfully updated.' }
        format.json { render :show, status: :ok, location: @trade }
      else
        format.html { render :edit }
        format.json { render json: @trade.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trades/1
  # DELETE /trades/1.json
  def destroy
    @trade.destroy
    respond_to do |format|
      format.html { redirect_to trades_url, notice: 'Trade was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_fpl_team
    @fpl_team = FplTeam.find_by(id: params[:fpl_team_id])
  end
end
