class Api::MyTicketsController < ApplicationController

  def index
    submitter = params[:user_email]
    my_tickets = ZEN_CLIENT.search(:query => "status<solved order_by:created_at submitter:#{submitter}")
    ticket_array = serialize_myticket_data(my_tickets)
    render json: {ticket: ticket_array}
  end


private
  def serialize_myticket_data(my_tickets)
    submitter_ids = []
    ticket_array = []
    my_tickets.all do | resource |
        ticket_array << {
          id: resource.id,
          problem_id: resource.problem_id,
          type: resource.type,
          subject: resource.subject,
          submitter: resource.submitter_id,
          created_at: resource.created_at,
          updated_at: resource.updated_at,
          status: resource.status,
          has_incidents: resource.has_incidents
          }
    submitter_ids << resource.submitter_id
  end

    users = ZEN_CLIENT.users.show_many(:ids => submitter_ids)

    submitter_user_data = {}

    users.all do |user|
      submitter_user_data[user.id] = user.name
    end

    ticket_array.each do | ticket |
      submitter_id = ticket[:submitter]
      ticket[:username] = submitter_user_data[submitter_id]
    end

    ticket_array
  end
end
