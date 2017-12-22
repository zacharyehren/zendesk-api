Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
     resources :tickets
     match 'tickets/new_comment' => 'tickets#new_comment', via: :post
     resources :closed_tickets, only: [:index, :show]
     match 'closed_tickets/new_comment' => 'closed_tickets#new_comment', via: :post
  end
end
