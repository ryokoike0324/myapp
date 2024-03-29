Rails.application.routes.draw do
  # contractor(受注者)
  devise_for :contractors, controllers: {
    sessions: 'contractors/sessions',
    passwords: 'contractors/passwords',
    registrations: 'contractors/registrations',
    confirmations: 'contractors/confirmations'
  }
  devise_scope :contractor do
    # ここのモデル名単数系にする
    post 'contractors/guest_login', to: 'contractors/sessions#guest_login'
  end

  resources :contractors do
    resource :profile, only: %i[show edit update], controller: 'contractors/profiles'
  end

  # client(発注者)
  devise_for :clients, controllers: {
    sessions: 'clients/sessions',
    passwords: 'clients/passwords',
    registrations: 'clients/registrations',
    confirmations: 'clients/confirmations'
  }

  devise_scope :client do
    post 'clients/guest_login', to: 'clients/sessions#guest_login'
    # put 'clients/confirmation', to: 'clients/confirmations#show'
  end
  # クライアントに紐づくプロファイルやリクエストのカスタムルート
  get 'clients/requests', to: 'clients/requests#index'
  resources :clients do
    resource :profile, only: %i[show edit update], controller: 'clients/profiles'
    resource :request, only: %i[show new edit create update], controller: 'clients/requests'
  end

  # only: []はそのリソースに対するルーティングを意図的に生成しないようにするためのものであり、ネストされたリソースに対するルーティングのみを生成したい
  resources :requests, only: [] do
    member do
      # /requests/:id/apply
      post 'apply', to: 'request_application#apply'
      # /requests/:id/cancel
      delete 'cancel', to: 'request_application#cancel_application'
    end
  end

  resources :contractors, only: [] do
    # /contractors/:contractor_id/request_applications
    resources :applications, only: [:index]
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
      get 'confirm'
      post 'back'
      get 'back'
      get 'done'
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
