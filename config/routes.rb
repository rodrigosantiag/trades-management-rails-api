require 'api_version_constraint'

Rails.application.routes.draw do
  devise_for :users, controllers: {confirmations: 'confirmations', passwords: 'passwords'}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api, defaults: {format: :json}, path: '/' do
    namespace :v1, path: '/', constraints: ApiVersionConstraint.new(version: 1, default: true) do
      mount_devise_token_auth_for 'User', at: 'auth'
      resources :brokers, only: [:index, :show, :create, :update, :destroy]
      resources :accounts, only: [:index, :show, :create, :update, :destroy]
      resources :trades, only: [:index, :create, :update, :destroy, :show] do
        collection do
          match 'analytics' => 'trades#analytics', via: :post, as: :analytics
        end
      end
      resources :strategies, only: [:index, :create, :update, :destroy, :show]
      controller :users do
        put 'reset_password/:reset_token_password', to: 'users#reset_password'
      end
      resources :users, only: [:show, :update]
    end
  end
end
