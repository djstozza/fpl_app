Rails.application.routes.draw do
  mount ActionCable.server => "/cable"
  resources :list_positions, only: :show

  resources :fpl_team_lists, only: [:show, :update] do
    resources :waiver_picks, only: [:create, :update, :destroy]
  end

  resources :fpl_teams, except: [:new, :create, :destroy] do
    resources :fpl_team_lists, only: [:index, :update]
    resources :waiver_picks, only: :index
    resources :trades, only: :create
  end

  resources :leagues, except: :destroy do
    resources :draft_picks, except: :destroy
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
