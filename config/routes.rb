# frozen_string_literal: true

require 'api_version_constraint'
require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users, controllers: { confirmations: 'confirmations', passwords: 'passwords' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api, defaults: { format: :json }, path: '/' do
    namespace :v1, path: '/', constraints: ApiVersionConstraint.new(version: 1, default: true) do
      mount_devise_token_auth_for 'User', at: 'auth'
      resources :brokers, only: %i[index show create update destroy]
      resources :accounts, only: %i[index show create update destroy]
      resources :trades, only: %i[index create update destroy show] do
        collection do
          post 'analytics' => 'trades#analytics', via: :post, as: :analytics
        end
      end
      resources :strategies, only: %i[index create update destroy show]
      controller :users do
        put 'reset_password/:reset_token_password', to: 'users#reset_password'
      end
      resources :users, only: %i[show update]
    end
  end

  mount Sidekiq::Web => '/sidekiq'
end
