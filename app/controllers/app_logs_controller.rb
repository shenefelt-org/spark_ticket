class AppLogsController < ApplicationController
  before_action :set_app_log, only: %i[ show update destroy ]

  # GET /app_logs
  def index
    @app_logs = AppLog.all

    render json: @app_logs
  end

  # GET /app_logs/1
  def show
    render json: @app_log
  end

  # POST /app_logs
  def create
    @app_log = AppLog.new(app_log_params)

    if @app_log.save
      render json: @app_log, status: :created, location: @app_log
    else
      render json: @app_log.errors, status: :unprocessable_content
    end
  end

  # PATCH/PUT /app_logs/1
  def update
    if @app_log.update(app_log_params)
      render json: @app_log
    else
      render json: @app_log.errors, status: :unprocessable_content
    end
  end

  # DELETE /app_logs/1
  def destroy
    @app_log.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app_log
      @app_log = AppLog.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def app_log_params
      params.expect(app_log: [ :level, :method, :path, :agent, :ip_address ])
    end
end
