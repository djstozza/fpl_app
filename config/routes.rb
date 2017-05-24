Rails.application.routes.draw do
  require 'sidekiq/web'
  require 'sidekiq-scheduler/web'
  mount Sidekiq::Web => '/sidekiq'

  root to: 'rounds#index'

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    registrations: 'users/registrations'
  }

  resources :rounds, only: [:show, :index]

  resources :players, only: [:show, :index] do
    collection do
      get 'player_dreamteam_datatable'
      get 'player_stats_datatable'
    end
  end

  resources :teams, only: [:show] do
    collection do
      get 'team_ladder_datatable'
      get 'team_player_datatable'
      get 'team_fixture_datatable'
    end
  end
end
