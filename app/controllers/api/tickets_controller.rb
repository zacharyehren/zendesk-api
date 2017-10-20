class Api::TicketsController < ApplicationController

  def index
    tickets = ZEN_CLIENT.tickets.to_a
    render json: serialize_tickets(tickets)
  end

  def show
    @ticket = ZEN_CLIENT.tickets.find!(params[:id])
  end

  private
  def serialize_tickets(tickets)
    new_tickets = []

    tickets.each do |ticket|
      ticket_hash = {}
      ticket_hash[:subject] = ticket.subject
      # Insert other stuff into the hash that we might need

      new_tickets << ticket_hash
    end

    new_tickets.to_json
  end
end
