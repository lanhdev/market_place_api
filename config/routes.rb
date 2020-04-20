require 'api_constraints'

Rails.application.routes.draw do
  devise_for :users, only: []
  namespace :api, defaults: { format: :json }, constraints: { subdomain: 'api' }, path: '/' do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :users, only: %i(show create update destroy)
      resources :sessions, only: %i(create destroy)
      resources :products, only: %i(show)
    end
  end
end
