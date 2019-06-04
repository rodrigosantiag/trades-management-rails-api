require 'api_version_constraint'

Rails.application.routes.draw do
  devise_for :users, controllers: {confirmations: 'confirmations'}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api, defaults: {format: :json}, path: '/', constraints: {subdomain: 'api'} do
    namespace :v1, path: '/', constraints: ApiVersionConstraint.new(version: 1, default: true) do
      mount_devise_token_auth_for 'User', at: 'auth'
      resources :brokers, only: [:index, :show, :create, :update, :destroy]
      resources :accounts, only: [:index, :show, :create, :update, :destroy]
    end
  end
end
