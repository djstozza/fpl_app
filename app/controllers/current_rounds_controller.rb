class CurrentRoundsController < ApplicationController
  respond_to :json
  # GET /current_rounds
  # GET /current_rounds.json
  def index
    render json: {
      current_round: Round.current_round,
      current_round_deadline: Round.deadline,
      current_round_status: Round.round_status
    }
  end
end
