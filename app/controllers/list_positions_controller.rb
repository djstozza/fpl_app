class ListPositionsController < ApplicationController
  before_action :set_list_position, only: [:show, :edit, :update, :destroy]

  # GET /list_positions
  # GET /list_positions.json
  def index
    @list_positions = ListPosition.all
  end

  # GET /list_positions/1
  # GET /list_positions/1.json
  def show
    respond_to do |format|
      format.json { render json: { options: ListPositionDecorator.new(@list_position).substitute_options } }
    end
  end

  # GET /list_positions/new
  def new
    @list_position = ListPosition.new
  end

  # GET /list_positions/1/edit
  def edit
  end

  # POST /list_positions
  # POST /list_positions.json
  def create
    @list_position = ListPosition.new(list_position_params)

    respond_to do |format|
      if @list_position.save
        format.html { redirect_to @list_position, notice: 'List position was successfully created.' }
        format.json { render :show, status: :created, location: @list_position }
      else
        format.html { render :new }
        format.json { render json: @list_position.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /list_positions/1
  # PATCH/PUT /list_positions/1.json
  def update
    respond_to do |format|
      if @list_position.update(list_position_params)
        format.html { redirect_to @list_position, notice: 'List position was successfully updated.' }
        format.json { render :show, status: :ok, location: @list_position }
      else
        format.html { render :edit }
        format.json { render json: @list_position.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /list_positions/1
  # DELETE /list_positions/1.json
  def destroy
    @list_position.destroy
    respond_to do |format|
      format.html { redirect_to list_positions_url, notice: 'List position was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_list_position
      @list_position = ListPosition.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def list_position_params
      params.fetch(:list_position, {})
    end
end
