Rails.application.routes.draw do
  # resources :join_leagues, only: [:new, :create]
  resources :draft_picks
  resources :fpl_team_lists
  resources :fpl_teams, except: [:new, :create]
  resources :leagues
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
