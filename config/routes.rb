require 'api_constraints'

Rails.application.routes.draw do
  devise_for :users, only: []
  namespace :api, defaults: { format: :json }, constraints: { subdomain: 'api' }, path: '/' do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :users, only: %i(show create update destroy) do
        resources :products, only: %i(create)
      end
      resources :sessions, only: %i(create destroy)
      resources :products, only: %i(index show)
    end
  end
end
