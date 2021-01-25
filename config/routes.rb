Rails.application.routes.draw do
  scope path: '/api' do
    api_version(module: "Api::V1", path: { value: "v1" }, defaults: { format: 'json' }) do
      post 'fintoc/:id/webhook', to: 'fintoc#webhook'
      get 'fintoc/:id', to: 'fintoc#show'
      post 'session', to: 'session#create'
    end
  end
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  get '/widget-completed-flow', to: 'widget#completed'

  devise_for :users
  mount Sidekiq::Web => '/queue'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: 'home#show'
end
