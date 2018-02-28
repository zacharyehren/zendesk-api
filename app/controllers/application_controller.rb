class ApplicationController < ActionController::API
  # refactor to smaller methods
  def serialize_ticket_data(sfa_data)
    @incident_tickets = []
    @submitter_ids = []
    @tickets = []
    @user_tickets = []

    sfa_data.all{ |resource| ticket_parse resource }
    @tickets.each{ |ticket| decorate_ticket ticket }
    @incident_tickets.each{ |ticket| decorate_ticket ticket }

    [@tickets, @incident_tickets, @user_tickets]
  end

  # authenticate user from front end
  def user_authentication
  end

  private

  def ticket_parse(resource)
    ticket = parse_zen_desk_resource resource
    case ticket[:type]
    when 'incident'
      @incident_tickets << ticket
    else
      @tickets << ticket
    end
    @submitter_ids << resource.submitter_id
  end

  def submitter_users
    @submitter_users ||= users.map{ |user| [user.zen_desk_id, user.name] }.to_h
  end

  def decorate_ticket(ticket)
    submitter_id = ticket[:submitter]
    ticket[:username] = submitter_users[submitter_id]
    # creates user tickets array
    @user_tickets << ticket if ticket[:username] == params[:username]
  end

  def parse_zen_desk_resource(resource)
    base_attrs = {
      id: resource.id,
      type: resource.type,
      subject: resource.subject,
      submitter: resource.submitter_id,
      created_at: resource.created_at,
      updated_at: resource.updated_at,
      status: resource.status
    }

    if resource.type == 'incident'
      base_attrs[:problem_id] = resource.problem_id
    else
      base_attrs[:has_incidents] = resource.has_incidents
    end

    base_attrs
  end

  def users
    @users ||= User.where zen_desk_id: @submitter_ids
  end
end
