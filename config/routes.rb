Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
     resources :tickets
     match 'tickets/comment' => 'tickets#comment', via: :get
  end
end
