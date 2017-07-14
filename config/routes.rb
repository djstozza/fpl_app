Rails.application.routes.draw do
  mount ActionCable.server => "/cable"
  resources :list_positions
  resources :fpl_team_lists, only: [:show, :update]

  resources :fpl_teams, except: [:new, :create] do
    resources :trades, only: :create
    resources :waiver_picks, only: [:index, :create, :update]
  end

  resources :leagues do
    resources :draft_picks
  end

  require 'sidekiq/web'
  require 'sidekiq-scheduler/web'
  mount Sidekiq::Web => '/sidekiq'

  get '/join-a-league', to: 'join_leagues#new', path: 'join-a-league'
  post '/join-a-league', to: 'join_leagues#create', as: 'join_leagues'

  root to: 'rounds#index'

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    registrations: 'users/registrations'
  }

  resources :rounds, only: [:show, :index]

  resources :players, only: [:show, :index]

  resources :teams, only: [:index, :show]
end
