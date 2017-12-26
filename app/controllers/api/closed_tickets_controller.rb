require 'date'
class Api::ClosedTicketsController < ApplicationController

  def index
    now = Date.today
    two_weeks_ago = (now - 14)
    sfa_closed_tickets = ZEN_CLIENT.search(:query => "tags:csm tags:sfa_other status:solved status:closed order_by:updated_at updated>" + two_weeks_ago.to_s)
    ticket_array, submitter_ids = serialize_csm_data(sfa_closed_tickets)
    users = ZEN_CLIENT.users.show_many(:ids => submitter_ids)
    submitter_user_data = {}
    users.all do |user|
      submitter_user_data[user.id] = user.name
    end
    render json: {ticket: ticket_array, users: submitter_user_data}
  end

  private
    def serialize_csm_data(sfa_data)
      submitter_ids = []
      ticket_array = []
      sfa_data.all do | resource |
        ticket_array << {
          id: resource.id,
          subject: resource.subject,
          submitter: resource.submitter_id,
          created_at: resource.created_at,
          updated_at: resource.updated_at,
          status: resource.status
        }
          submitter_ids << resource.submitter_id
    end
    [ticket_array, submitter_ids]
  end
end
