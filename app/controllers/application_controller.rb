class ApplicationController < ActionController::API

  def serialize_ticket_data(sfa_data)
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
