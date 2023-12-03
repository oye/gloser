Rails.application.routes.draw do
  resources :runs do
    member do
      get :level_one
      get :level_two
      get :completed
      post :next
      post :level_one_answer
      post :level_two_answer
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  root 'runs#new'
end
