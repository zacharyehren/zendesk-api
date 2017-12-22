require 'date'
class Api::ClosedTicketsController < ApplicationController

  def index
    now = Date.today
    two_weeks_ago = (now - 14)
    sfa_closed_tickets = ZEN_CLIENT.search(:query => "tags:csm tags:sfa_other status:solved updated>" + two_weeks_ago.to_s)
    puts sfa_closed_tickets
  end

end
