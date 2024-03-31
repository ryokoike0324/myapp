Rails.application.routes.draw do

  # ###Contractor##################################

  # ---contractor/devise関係-------------------
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

  # ---contractors/profiles----------------
  # deviseにより提供されるcurrent_contractorがあるためcontractor_idは不要になる
  # 不要なidをURLに露出させないためにresourcesでなくnamespaceを使う
  namespace :contractors do
    resource :profile, only: [:show, :edit, :update]
  end

  # ---contractors/request_applications----------------
  # only: []はそのリソースに対するルーティングを意図的に生成しないようにするためのものであり、ネストされたリソースに対するルーティングのみを生成したい
  namespace :contractors do
    resources :request_applications, only: [:index, :create, :destroy]
  end

  # ###Client##################################

  # ---client/devise関係-------------------
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

  # ---clients/requests----------------------
  # controllers/clients/以下にcontrollerを配置している場合namespaceメソッドでネストするかmodule: :clientsオプションをつける
  get 'clients/requests', to: 'clients/requests#index'
  namespace :clients do
    resource :request, only: [:show, :new, :edit, :create, :update]
  end

  # ---clients/profiles----------------------
  namespace :clients do
    resource :profile, only: [:show, :edit, :update]
  end

  # ---clients/applicants--------------------
  namespace :clients do
    resources :applicants, only: [:index, :show]
  end

  # ---clients/engagements--------------------
  namespace :clients do
    resources :engagements, only: [:create]
  end


  # ###その他###############################

  # ---static_pages--------------------------
  root 'static_pages#about'
  get 'about' => 'static_pages#about'
  get 'privacy' => 'static_pages#privacy'
  get 'terms' => 'static_pages#terms'
  get 'signup' =>  'static_pages#signup'
  get 'login' =>  'static_pages#login'
  get 'guest_login' =>  'static_pages#guest_login'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # ---contacts------------------------------
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
