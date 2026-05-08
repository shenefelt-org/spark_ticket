class TechesController < ApplicationController
  before_action :set_tech, only: %i[ show update destroy ]

  # GET /teches
  def index
    @teches = Tech.all

    render json: @teches
  end

  # GET /teches/1
  def show
    render json: @tech
  end

  # POST /teches
  def create
    @tech = Tech.new(tech_params)

    if @tech.save
      render json: @tech, status: :created, location: @tech
    else
      render json: @tech.errors, status: :unprocessable_content
    end
  end

  # PATCH/PUT /teches/1
  def update
    if @tech.update(tech_params)
      render json: @tech
    else
      render json: @tech.errors, status: :unprocessable_content
    end
  end

  # DELETE /teches/1
  def destroy
    @tech.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tech
      @tech = Tech.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def tech_params
      params.expect(tech: [ :first_name, :last_name, :role, :employee_id ])
    end
end
