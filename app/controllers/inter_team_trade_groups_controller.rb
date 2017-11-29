class InterTeamTradeGroupsController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token
  before_action :set_fpl_team, :set_fpl_team_list, :set_out_trade_groups
  before_action :set_inter_team_trade_group, only: [:show, :edit, :update]
  respond_to :json, except: :index

  # GET /inter_team_trade_groups
  # GET /inter_team_trade_groups.json
  def index
    respond_to do |format|
      format.html
      format.json {
        render json: { out_trade_groups: @out_trade_groups }
      }
    end
    # @inter_team_trade_groups = InterTeamTradeGroup.all
  end

  # GET /inter_team_trade_groups/1
  # GET /inter_team_trade_groups/1.json
  def show
    decorator = TradeGroupDecorator.new(@inter_team_trade_group)

    render json: {
      in_players_tradeable: decorator.in_players_tradeable,
      out_players_tradeable: decorator.out_players_tradeable,
      out_trade_groups: @out_trade_groups
    }
  end

  # GET /inter_team_trade_groups/new
  def new
    decorator = TradeGroupDecorator.new(
      InterTeamTradeGroup.new(
        out_fpl_team_list: @fpl_team_list,
        round_id: Round.current_round.id,
        league: @fpl_team.league
      )
    )

    render json: {
      in_players_tradeable: decorator.in_players_tradeable,
      out_players_tradeable: decorator.out_players_tradeable,
      out_trade_groups: @out_trade_groups
    }
  end

  # GET /inter_team_trade_groups/1/edit
  def edit
  end

  # POST /inter_team_trade_groups
  # POST /inter_team_trade_groups.json
  def create
    outcome = InterTeamTradeGroups::Create.run(params.merge(current_user: current_user))
    out_trade_groups = TradeGroupsDecorator.new(InterTeamTradeGroup.where(out_fpl_team_list: @fpl_team_list)).all_trades

    if outcome.valid?
      render json: {
        out_trade_groups: out_trade_groups,
        success: "Successfully created a pending trade - Fpl Team: #{outcome.in_fpl_team.name}, Out: #{outcome.out_player.name} " \
                   "In: #{outcome.in_player.name}."
      }
    else
      render json: {
        out_trade_groups: out_trade_groups,
        errors: outcome.errors
      }
    end
  end

  # PATCH/PUT /inter_team_trade_groups/1
  # PATCH/PUT /inter_team_trade_groups/1.json
  def update
    respond_to do |format|
      if @inter_team_trade_group.update(inter_team_trade_group_params)
        format.html { redirect_to @inter_team_trade_group, notice: 'Inter team trade group was successfully updated.' }
        format.json { render :show, status: :ok, location: @inter_team_trade_group }
      else
        format.html { render :edit }
        format.json { render json: @inter_team_trade_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /inter_team_trade_groups/1
  # DELETE /inter_team_trade_groups/1.json
  def destroy
    @inter_team_trade_group.destroy
    respond_to do |format|
      format.html { redirect_to inter_team_trade_groups_url, notice: 'Inter team trade group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_fpl_team
    @fpl_team = FplTeam.find(params[:fpl_team_id])
  end

  def set_fpl_team_list
    @fpl_team_list = FplTeamList.find(params[:fpl_team_list_id])
  end

  def set_out_trade_groups
    @out_trade_groups = TradeGroupsDecorator.new(InterTeamTradeGroup.where(out_fpl_team_list: @fpl_team_list)).all_trades
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_inter_team_trade_group
    @inter_team_trade_group = InterTeamTradeGroup.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def inter_team_trade_group_params
    params.fetch(:inter_team_trade_group, {})
  end
end
