class Api::TicketsController < ApplicationController

  def index
    tickets = ZEN_CLIENT.tickets
    render json: serialize_tickets(tickets)
  end

  def show
    ticket = ZD_Request.get_comments(:id)
  end

  private
  def serialize_tickets(tickets)
    ticket_array = []
    tickets.all do | resource |
      ticket_array << {id: resource.id, subject: resource.subject }
    end
    # new_tickets = []
    #
    # tickets.each do |ticket|
    #   ticket_hash = {}
    #   ticket_hash[:subject] = ticket.subject
    #   # Insert other stuff from tickets into the hash that's needed
    #
    #   new_tickets << ticket_hash
    # end
    #
    # new_tickets.to_json
    ticket_array
  end
end
