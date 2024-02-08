Rails.application.routes.draw do
  devise_for :contractors, controllers: {
    sessions:      'contractors/sessions',
    passwords:     'contractors/passwords',
    registrations: 'contractors/registrations'
  }
  devise_for :clients, controllers: {
    sessions:      'clients/sessions',
    passwords:     'clients/passwords',
    registrations: 'clients/registrations'
  }
  # 共通のログイン画面用のルート、重複するためclientは作成しない（同じパスのため）
  devise_scope :contractor do
    get '/login', to: 'devise/sessions#new'
    post '/login', to: 'devise/sessions#create'
  end

  root 'static_pages#about'
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
