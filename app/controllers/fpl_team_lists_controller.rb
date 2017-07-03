class FplTeamListsController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token
  before_action :set_fpl_team_list, only: [:show, :edit, :update, :destroy]

  # GET /fpl_team_lists
  # GET /fpl_team_lists.json
  def index
    @fpl_team_lists = FplTeamList.all
  end

  # GET /fpl_team_lists/1
  # GET /fpl_team_lists/1.json
  def show
  end

  # GET /fpl_team_lists/new
  def new
    @fpl_team_list = FplTeamList.new
  end

  # GET /fpl_team_lists/1/edit
  def edit
  end

  # POST /fpl_team_lists
  # POST /fpl_team_lists.json
  def create
    @fpl_team_list = FplTeamList.new(fpl_team_list_params)

    respond_to do |format|
      if @fpl_team_list.save
        format.html { redirect_to @fpl_team_list, notice: 'Fpl team list was successfully created.' }
        format.json { render :show, status: :created, location: @fpl_team_list }
      else
        format.html { render :new }
        format.json { render json: @fpl_team_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fpl_team_lists/1
  # PATCH/PUT /fpl_team_lists/1.json
  def update
    player = Player.find_by(id: params[:player_id])
    target = Player.find_by(id: params[:target_id])
    form = ::FplTeams::ProcessSubstitutionForm.new(
      fpl_team_list: @fpl_team_list,
      player: player,
      target: target,
      current_user: current_user
    )
    respond_to do |format|
      if form.save
        format.json do
          render json: {
            line_up: ListPositionsDecorator.new(@fpl_team_list.list_positions).list_position_arr,
            success: "Successfully substituted #{player.name} with #{target.name}."
          }
        end
      else
        format.json { render json: form.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fpl_team_lists/1
  # DELETE /fpl_team_lists/1.json
  def destroy
    @fpl_team_list.destroy
    respond_to do |format|
      format.html { redirect_to fpl_team_lists_url, notice: 'Fpl team list was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fpl_team_list
      @fpl_team_list = FplTeamList.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fpl_team_list_params
      params.fetch(:fpl_team_list, {})
    end
end
