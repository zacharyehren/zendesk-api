class Api::MyTicketsController < ApplicationController

  def index
    sfa_tickets = ZEN_CLIENT.search(:query => "status<solved order_by:created_at submitter:zehren@sharethrough.com")
    ticket_array = serialize_ticket_data(sfa_tickets)
    render json: {ticket: ticket_array}
  end


end
