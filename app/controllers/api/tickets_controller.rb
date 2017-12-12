class Api::TicketsController < ApplicationController

  def index
    tickets = ZEN_CLIENT.search(:query => "tags:csm tags:sfa_other tags:advertiser_user status<solved order_by:created_at").include(:users).include(:tickets)
    render json: serialize_tickets(tickets)
  end

  def show
    comment = ZEN_CLIENT.tickets.find(id: params[:id]).comments.include(:users)
    render json: serialize_comment(comment)
  end

  def create
    new_ticket = ZEN_CLIENT.tickets.create(
      :subject => params[:subject],
      :comment => { :value => params[:comment_body] },
      :requester => { :name => params[:submitter] },
      :email => params[:submitter]
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
    def serialize_tickets(tickets)
      puts tickets
      ticket_array = []
      tickets.all do | resource |
        submitter_name = resource.submitter.name
        ticket_array << {
          id: resource.id,
          subject: resource.subject,
          submitter: submitter_name,
          created_at: resource.created_at }
    end
    ticket_array
  end

  def serialize_comment(comment)
    comment_array = []
    comment.all do | resource |
      sender = resource.author
      comment_array << {
        body: resource.body,
        sender: sender.name }
    end
    comment_array
  end
end
