class Api::TicketsController < ApplicationController

  def index
    sfa_tickets = ZEN_CLIENT.search(:query => "tags:csm tags:sfa_other status<solved order_by:created_at")
    ticket_array, submitter_ids = serialize_csm_data(sfa_tickets)
    users = ZEN_CLIENT.users.show_many(:ids => submitter_ids)
    submitter_user_data = {}
    users.all do |user|
      submitter_user_data[user.id] = user.name
    end
    render json: {ticket: ticket_array, users: submitter_user_data}
  end

  def show
    ticket = ZEN_CLIENT.tickets.find(id: params[:id])
    comments = ticket.comments.fetch
    #filters out private comments
    public_comments = comments.select {|c| c.public == true}
    render json: serialize_comment(public_comments)
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

  def serialize_comment(comment)
    comment_array = []
    comment.each do | resource |
      sender = resource.author
      comment_array << {
        body: resource.body,
        sender: sender.name }
    end
    comment_array
  end
end
