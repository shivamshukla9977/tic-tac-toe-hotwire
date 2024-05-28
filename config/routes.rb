Rails.application.routes.draw do
  resources :games do 
    member do
      post 'end_turn'
    end
    resources :moves
  end
  root 'games#index'
end
