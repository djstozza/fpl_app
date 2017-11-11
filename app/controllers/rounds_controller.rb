class RoundsController < ApplicationController
  # GET /rounds
  # GET /rounds.json
  def index
    rounds_decorator = RoundsDecorator.new(Round.all)
    current_round = Round.current_round
    respond_to do |format|
      format.html
      format.json do
        render json: {
          round: current_round,
          fixtures: current_round.fixture_stats,
          rounds: rounds_decorator.all_data
        }
      end
    end
  end

  # GET /rounds/1
  # GET /rounds/1.json
  def show
    round_decorator = RoundDecorator.new(Round.find_by(id: params[:id]))
    respond_to do |format|
      format.html
      format.json { render json: { round: round_decorator, fixtures: round_decorator.fixture_stats } }
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def round_params
    params.fetch(:round, {})
  end
end
