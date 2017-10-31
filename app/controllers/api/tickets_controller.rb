class Api::TicketsController < ApplicationController

  def index
    tickets = ZEN_CLIENT.tickets
    render json: serialize_tickets(tickets)
  end

  def show
    comment = ZEN_CLIENT.tickets.find(id: params[:id]).comments
    render json: serialize_comment(comment)
  end

  def create
    new_ticket = ZEN_CLIENT.tickets.create(
      :subject => params[:subject],
      :comment => { :value => params[:comment_body] },
      :via => { :source => { :from => { :name => params[:submitter] }}},
      :requester => { :name => params[:submitter] }
    )
  end

  def new_comment
    user = ZEN_CLIENT.users.search(:query => params[:user_email])
    ticket = ZEN_CLIENT.tickets.find(id: params[:id])
    binding.pry
    #passing in the user id as the author_id should pull in the end-users info in the submitted comment according to https://support.zendesk.com/hc/en-us/community/posts/207597658-Adding-comments-to-existing-ticket-as-end-user
    ticket.update(comment: {:body => comment_body, :author_id => user.id })
    ticket.save
  end

  private
    def serialize_tickets(tickets)
      ticket_array = []
      tickets.all do | resource |
        ticket_array << {id: resource.id, subject: resource.subject }
    end
    ticket_array
  end

  def serialize_comment(comment)
    comment_array = []
    comment.all do | resource |
      comment_array << { body: resource.body, sender: resource.via.source.from.name }
    end
    comment_array
  end
end
