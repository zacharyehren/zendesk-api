class Api::TicketsController < ApplicationController

  def index
    sfa_tickets = ZEN_CLIENT.search(:query => "tags:csm tags:sfa_other status<solved order_by:created_at -tags:child_ticket")
    ticket_array, incident_ticket_array = serialize_ticket_data(sfa_tickets)
    render json: {ticket: ticket_array, incidents: incident_ticket_array}
  end

  def show
    ticket = ZEN_CLIENT.tickets.find(id: params[:id])
    comments = ticket.comments.include(:users).fetch
    #filters out private comments
    public_comments = comments.select {|c| c.public == true}
    render json: serialize_comment(public_comments)
  end

  def create
    new_ticket = ZEN_CLIENT.tickets.create(
      :subject => params[:subject],
      :comment => { :value => params[:comment_body] },
      :requester => { :name => params[:submitter_name] },
      :email => params[:submitter_email]
    )
  end

  def new_comment
    user = ZEN_CLIENT.users.search(:query => params[:user_email])
    user_id = user.first.id
    ticket = ZEN_CLIENT.tickets.find(id: params[:id])
    #passing in the user id as the author_id pulls in the end-users info in the submitted comment according to https://support.zendesk.com/hc/en-us/community/posts/207597658-Adding-comments-to-existing-ticket-as-end-user
    ticket.update(
      comment: {
        :body => params[:comment_body],
        :author_id => user_id
      })
    # ticket.comment.uploads << File.new(params[:file])
    ticket.save
  end

  private

  def serialize_comment(comment)
    comment_array = []
    comment.each do | resource |
      comment_array << {
        body: resource.body,
        created_at: resource.created_at,
        sender: resource.author.name }
    end
    comment_array
  end
end
