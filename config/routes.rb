Rails.application.routes.draw do

  devise_for :contractors, controllers: {
    sessions: 'contractors/sessions',
    passwords: 'contractors/passwords',
    registrations: 'contractors/registrations'
  }
  devise_for :clients, controllers: {
    sessions: 'clients/sessions',
    passwords: 'clients/passwords',
    registrations: 'clients/registrations'
  }

  devise_scope :contractor do
    # ここのモデル名単数系にするそうですよ
    post 'contractors/guest_login', to: 'contractors/sessions#guest_login'
  end
  devise_scope :client do
    post 'clients/guest_login', to: 'clients/sessions#guest_login'
  end



  root 'static_pages#about'
  get 'about' => 'static_pages#about'
  get 'privacy' => 'static_pages#privacy'
  get 'terms' => 'static_pages#terms'
  get 'signup' =>  'static_pages#signup'
  get 'login' =>  'static_pages#login'
  get 'guest_login' =>  'static_pages#guest_login'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :contacts, only: [:new, :create] do
    collection do
      post 'confirm'
      post 'back'
      get 'done'
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
