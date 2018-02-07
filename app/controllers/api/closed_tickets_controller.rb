require 'date'
class Api::ClosedTicketsController < ApplicationController

  def index
    now = Date.today
    two_weeks_ago = (now - 14)
    sfa_closed_tickets = ZEN_CLIENT.search(:query => "tags:csm tags:sfa_other status:solved status:closed order_by:updated_at updated>#{two_weeks_ago.to_s}")
    ticket_array, incident_ticket_array = serialize_ticket_data(sfa_closed_tickets)
    render json: {ticket: ticket_array, incidents: incident_ticket_array }
  end

end
