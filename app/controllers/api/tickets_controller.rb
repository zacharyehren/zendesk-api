class Api::TicketsController < ApplicationController

  def index
    @tickets = ZEN_CLIENT.tickets
    puts @tickets
    render @tickets
  end

end
