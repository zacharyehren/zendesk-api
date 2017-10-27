class Api::TicketsController < ApplicationController

  def index
    tickets = ZEN_CLIENT.tickets
    render json: serialize_tickets(tickets)
  end

  def show
    comment = ZEN_CLIENT.tickets.find(id: params[:id]).comments
    render json: serialize_comment(comment)
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
