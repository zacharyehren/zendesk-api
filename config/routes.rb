Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
     resources :tickets
     match 'tickets/new_comment' => 'tickets#new_comment', via: :post
  end
end
