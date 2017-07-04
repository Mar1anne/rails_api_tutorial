require 'api_constraints'

Rails.application.routes.draw do

  # Api definition
  namespace :api, defaults: { format: :json }  do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      # We are going to list our resources here
      resources :users, only: [:show, :create, :update, :destroy] do
        resources :products, only: [:create, :update, :destroy]
        resources :orders, only: [:index, :show, :create]
      end
      resources :users, only: [:index]
      resources :sessions, only: [:create, :destroy]
      resources :products, only: [:show, :index]
    end
  end

end
