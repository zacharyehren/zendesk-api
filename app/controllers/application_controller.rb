class ApplicationController < ActionController::API

  def serialize_ticket_data(sfa_data)
    submitter_ids = []
    ticket_array = []
    incident_ticket_array = []
    sfa_data.all do | resource |
      if resource.type == "incident"
        incident_ticket_array << {
          id: resource.id,
          problem_id: resource.problem_id,
          type: resource.type,
          subject: resource.subject,
          submitter: resource.submitter_id,
          created_at: resource.created_at,
          updated_at: resource.updated_at,
          status: resource.status,
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
          }
    end
    submitter_ids << resource.submitter_id
  end

    users = ZEN_CLIENT.users.show_many(:ids => submitter_ids)

    submitter_user_data = {}

    users.all do |user|
      submitter_user_data[user.id] = user.name
    end

    def create_users(ticket_object, submitter_user_data)
      ticket_object.each do | ticket |
        submitter_id = ticket[:submitter]
        ticket[:username] = submitter_user_data[submitter_id]
      end
    end

    create_users(ticket_array, submitter_user_data)
    create_users(incident_ticket_array, submitter_user_data)

    [ticket_array, incident_ticket_array]
  end
end
