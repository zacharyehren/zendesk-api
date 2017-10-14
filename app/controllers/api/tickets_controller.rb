class Api::TicketsController < ApplicationController

  def index
    @tickets = ZEN_CLIENT.tickets
    puts @tickets
    render @tickets
  end

  def show
    @ticket = ZEN_CLIENT.tickets.find!(params[:id])
  end

end
