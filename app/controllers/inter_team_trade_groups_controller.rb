class InterTeamTradeGroupsController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token
  before_action :set_fpl_team,
                :set_fpl_team_list,
                :set_new_trade_group
  before_action :set_inter_team_trade_group, only: [:show, :update, :destroy]
  respond_to :json, except: :index
  before_action :authorised_user, only: :index

  # GET /fpl_teams/1/inter_team_trade_groups
  # GET /fpl_teams/1/inter_team_trade_groups.json
  def index
    respond_to do |format|
      format.html
      format.json { render json: trade_group_hash }
    end
  end

  # POST /fpl_teams/1/inter_team_trade_groups
  # POST /fpl_teams/1/inter_team_trade_groups.json
  def create
    outcome =
      InterTeamTradeGroups::Create.run(
        params.merge(
          inter_team_trade_group: InterTeamTradeGroup.new(out_fpl_team_list: @fpl_team_list),
          current_user: current_user
        )
      )

    if outcome.valid?
      render json: trade_group_hash.merge(
        success: "Successfully created a pending trade - Fpl Team: #{outcome.in_fpl_team.name}, " \
                  "Out: #{outcome.out_player.name} In: #{outcome.in_player.name}."
      )
    else
      render json: trade_group_hash.merge(errors: outcome.errors.full_messages),
        status: :unprocessable_entity
    end
  end

  # PATCH/PUT /fpl_teams/1/inter_team_trade_groups/1
  # PATCH/PUT /fpl_teams/1/inter_team_trade_groups/1.json
  def update
    outcome = "InterTeamTradeGroups::#{params[:trade_action]}".constantize.run(
      params.merge(
        inter_team_trade_group: @inter_team_trade_group,
        current_user: current_user
      )
    )

    if outcome.valid?
      render json: trade_group_hash.merge(success: outcome.success_message)
    else
      render json: trade_group_hash.merge(errors: outcome.errors.full_messages),
        status: :unprocessable_entity
    end
  end

  # DELETE /fpl_teams/1/inter_team_trade_groups/1
  # DELETE /fpl_teams/1/inter_team_trade_groups/1.json
  def destroy
    outcome =
      InterTeamTradeGroups::Delete.run(
        inter_team_trade_group: @inter_team_trade_group,
        current_user: current_user
      )

    if outcome.valid?
      render json: trade_group_hash
    else
      render json: trade_group_hash.merge(errors: outcome.errors.full_messages),
        status: :unprocessable_entity
    end
  end

  private

  def set_fpl_team
    @fpl_team = FplTeam.find(params[:fpl_team_id])
  end

  def set_fpl_team_list
    @fpl_team_list = @fpl_team.fpl_team_lists.find_by(round_id: Round.current_round.id)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_inter_team_trade_group
    @inter_team_trade_group = InterTeamTradeGroup.find(params[:id])
  end

  def set_new_trade_group
    @new_trade_group =
      TradeGroupDecorator.new(
        InterTeamTradeGroup.new(
          out_fpl_team_list: @fpl_team_list,
          round_id: Round.current_round.id,
          league: @fpl_team.league
        )
      )
  end

  def trade_group_hash
    out_trade_groups =
      TradeGroupsDecorator.new(InterTeamTradeGroup.where(out_fpl_team_list: @fpl_team_list)).all_trades

    in_trade_groups =
      TradeGroupsDecorator.new(
        InterTeamTradeGroup.where(in_fpl_team_list: @fpl_team_list).where.not(status: 'pending')
      ).all_trades

    {
      status: Round.round_status,
      in_players_tradeable: @new_trade_group.in_players_tradeable,
      out_players_tradeable: @new_trade_group.out_players_tradeable,
      out_trade_groups: out_trade_groups,
      in_trade_groups: in_trade_groups
    }
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def inter_team_trade_group_params
    params.fetch(:inter_team_trade_group, {})
  end

  def authorised_user
    if @fpl_team.user != current_user
      @fpl_team =
        FplTeam.find_by(league: @fpl_team.league, user: current_user) || current_user.fpl_teams.first
      redirect_to fpl_team_inter_team_trade_groups_path(fpl_team_id: @fpl_team)
    end
  end
end
