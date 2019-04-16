Rails.application.routes.draw do

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'welcome#index'

  resources :items, only: [:index,:show], param: :slug

  resources :merchants, only: [:index]

  resources :users, only: [:new, :edit], param: :slug

  resources :carts, only: [:create, :edit]

  resources :ratings, only: [:new, :create]


  get '/login', to: "sessions#new"
  post '/login', to: "sessions#create"

  get '/logout', to: "sessions#destroy"

  get '/profile', to: "users#show"
  post "/profile", to: "users#create"
  patch "/profile", to: "users#update"

  namespace :profile do
    resources :orders, only: [:index, :show, :update, :create]
  end

  namespace :dashboard do
    resources :items, only: [:index, :new, :update, :destroy, :create, :edit] do
      member { patch :activate }
      member { patch :deactivate }
    end
    resources :orders, only: [:show, :update, :edit]
  end

  get '/cart', to: "carts#show"
  delete '/cart', to: "carts#destroy"
  patch '/cart', to: "carts#update"

  get '/dashboard', to: "merchants#show"

  namespace :admin do
    get '/dashboard', to: 'admins#show'
    resources :users, only: [:index, :show, :update], param: :slug
    resources :orders, only: [:update]
    resources :merchants, only: [:show, :index], param: :slug do
      member {patch :activate}
      member {patch :deactivate}
      member {patch :downgrade}
    end
  end


end
