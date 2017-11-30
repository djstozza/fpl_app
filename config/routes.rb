Rails.application.routes.draw do
  mount ActionCable.server => "/cable"
  resources :list_positions, only: :show
  resources :positions, only: :index

  resources :fpl_teams, except: [:new, :create, :destroy] do
    resources :fpl_team_lists, only: [:index, :show, :update] do
      resources :waiver_picks, only: [:create, :update, :destroy]
      resources :inter_team_trade_groups, except: [:new, :show, :edit]
    end
    resources :waiver_picks, only: :index
    resources :trades, only: :create
  end

  resources :leagues, except: [:index, :destroy] do
    resources :draft_picks, only: [:index, :create, :update]
    resources :mini_draft_picks, only: [:index, :create]
    resources :pass_mini_draft_picks, only: :create
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
