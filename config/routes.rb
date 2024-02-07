Rails.application.routes.draw do
  root 'static_pages#about'
  devise_for :clients
  devise_for :contractors
  get 'static_pages/about'
  get 'static_pages/privacy'
  get 'static_pages/terms'
  get 'static_pages/signup_type'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
