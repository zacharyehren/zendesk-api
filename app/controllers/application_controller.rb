class ApplicationController < ActionController::API
  def serialize_ticket_data(sfa_data)
    submitter_ids = []
    ticket_array = []
    incident_ticket_array = []
    user_ticket_array = []

    sfa_data.all do |resource|
      if resource.type == 'incident'
        incident_ticket_array << {
          id: resource.id,
          problem_id: resource.problem_id,
          type: resource.type,
          subject: resource.subject,
          submitter: resource.submitter_id,
          created_at: resource.created_at,
          updated_at: resource.updated_at,
          status: resource.status
        }
      else
        ticket_array << {
          id: resource.id,
          type: resource.type,
          subject: resource.subject,
          submitter: resource.submitter_id,
          created_at: resource.created_at,
          updated_at: resource.updated_at,
          status: resource.status,
          has_incidents: resource.has_incidents
        }
    end
      submitter_ids << resource.submitter_id
    end

    users = User.where zen_desk_id: submitter_ids

    submitter_user_data = {}

    users.each do |user|
      submitter_user_data[user.zen_desk_id] = user.name
    end

    add_username_to_tickets = lambda do |ticket|
      submitter_id = ticket[:submitter]
      ticket[:username] = submitter_user_data[submitter_id]
      # creates user tickets array
      user_ticket_array << ticket if ticket[:username] == params[:username]
    end

    ticket_array.each(&add_username_to_tickets)
    incident_ticket_array.each(&add_username_to_tickets)

    [ticket_array, incident_ticket_array, user_ticket_array]
  end
end
