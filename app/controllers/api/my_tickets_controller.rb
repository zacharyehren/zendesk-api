class Api::MyTicketsController < ApplicationController

  def index
    sfa_tickets = ZEN_CLIENT.search(:query => "status<solved order_by:created_at submitter:zehren@sharethrough.com")
    ticket_array = serialize_csm_data(sfa_tickets)
    render json: {ticket: ticket_array}
  end


  private
    def serialize_csm_data(sfa_data)
      submitter_ids = []
      ticket_array = []
      sfa_data.all do | resource |
        ticket_array << {
          id: resource.id,
          subject: resource.subject,
          created_at: resource.created_at,
          updated_at: resource.updated_at,
          status: resource.status
        }
          submitter_ids << resource.submitter_id
    end

    ticket_array
  end

end
