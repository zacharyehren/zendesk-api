class Api::MyTicketsController < ApplicationController

  def index
    submitter = params[:user_email]
    sfa_tickets = ZEN_CLIENT.search(:query => "status<solved order_by:created_at submitter:#{submitter}")
    ticket_array, incident_ticket_array = serialize_ticket_data(sfa_tickets)
    render json: {ticket: ticket_array, incidents: incident_ticket_array}
  end

end
