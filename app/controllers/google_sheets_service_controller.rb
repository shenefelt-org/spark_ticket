# app/controllers/google_sheets_service_controller.rb
unless defined?(Bignum)
    Bignum = Integer
end

unless defined?(Fixnum)
    Fixnum = Integer
end

require 'tty'
require 'tty-prompt'
require 'pastel'

class GoogleSheetsServiceController < ApplicationController
  skip_before_action :verify_authenticity_token, raise: false

  def receive
    pastel = Pastel.new
    prompt = TTY::Prompt.new

    # Build the ticket using only the permitted fields
    @ticket = Ticket.create(
      subject:  params[:subject],
      body:     params[:body],
      status:   params[:status],
      priority: params[:priority],
      uploaded: true,
    )

    msg = "Received webhook for Ticket: #{pastel.bold.blue(@ticket.subject)} with status: #{pastel.bold.yellow(@ticket.status)} and priority: #{pastel.bold.red(@ticket.priority)}"
    prompt.say(msg)
    if @ticket.save
      msg = "#{pastel.bold.green('Success!')} Ticket created with ID: #{@ticket.id}"
      prompt.say(msg)
      render json: { status: 'success', ticket_id: @ticket.id }, status: :created
    else
      msg = "#{pastel.bold.red('WEBHOOK ERROR:')} Failed to create ticket. #{@ticket.errors.full_messages.join(', ')}"
      prompt.say(msg)
      render json: { status: 'error', errors: @ticket.errors.full_messages }, status: :unprocessable_entity
    end
  end
end