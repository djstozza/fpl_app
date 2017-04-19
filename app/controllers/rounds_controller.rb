class RoundsController < ApplicationController
  before_action :set_round, only: [:show]
  before_action :set_rounds, only: [:show, :index]

  # GET /rounds
  # GET /rounds.json
  def index
    @round_decorator = RoundDecorator.new(Round.find_by(is_current: true))
  end

  # GET /rounds/1
  # GET /rounds/1.json
  def show
    @round_decorator = RoundDecorator.new(@round)
    respond_to do |format|
      format.html
      format.json { render json: { round: @round_decorator, fixtures: @round_decorator.fixture_stats} }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_round
    @round = Round.find(params[:id])
  end

  def set_rounds
    @rounds = Round.all
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def round_params
    params.fetch(:round, {})
  end
end
