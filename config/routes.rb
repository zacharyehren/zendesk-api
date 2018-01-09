Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
     resources :tickets
     match 'tickets/new_comment' => 'tickets#new_comment', via: :post
     resources :closed_tickets, only: [:index, :show]
     resources :my_tickets
  end
end
