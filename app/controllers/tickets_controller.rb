class TicketsController < ApplicationController
  before_action :set_ticket, only: %i[ show update destroy ]

  # GET /tickets
  def index
    @tickets = Ticket.all
    AppLog.create!(
      level: "INFO",
      method: request.method,
      path: request.path,
      agent: request.user_agent,
      ip_address: request.remote_ip
    )

    render json: {
      message: "Request logged: METHOD: #{request.method} | PATH: #{request.path} | Request From: #{request.remote_ip}",
      data: @tickets.as_json(include: :teches)
    }
  end

  # GET /tickets/1
  def show
    render json: @ticket.as_json(include: :teches)
  end

  # POST /tickets
  def create
    @ticket = Ticket.new(ticket_params)

    if @ticket.save
      render json: @ticket, status: :created, location: @ticket
    else
      render json: @ticket.errors, status: :unprocessable_content
    end
  end

  # PATCH/PUT /tickets/1
  def update
    if @ticket.update(ticket_params)
      render json: @ticket
    else
      render json: @ticket.errors, status: :unprocessable_content
    end
  end

  # DELETE /tickets/1
  def destroy
    @ticket.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between ::::::::actions.
    def set_ticket
      @ticket = Ticket.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def ticket_params
      params.expect(ticket: [ :subject, :body, :status, :priority, :uploaded ])
    end
end
