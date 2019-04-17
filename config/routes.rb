Rails.application.routes.draw do

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'welcome#index'

  resources :items, only: [:index,:show]

  resources :merchants, only: [:index]

  resources :users, only: [:new, :edit]

  resources :carts, only: [:create, :edit]


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
    resources :coupons, only: [:index, :show, :edit, :update, :destroy, :new, :create] do
      member {patch :activate}
      member {patch :deactivate}
    end
  end

  get '/cart', to: "carts#show"
  delete '/cart', to: "carts#destroy"
  patch '/cart', to: "carts#update"
  patch '/discount/cart', to: "carts#discount"

  get '/dashboard', to: "merchants#show"

  namespace :admin do
    get '/dashboard', to: 'admins#show'
    resources :users, only: [:index, :show, :update]
    resources :orders, only: [:update]
    resources :merchants, only: [:show, :index] do
      member {patch :activate}
      member {patch :deactivate}
      member {patch :downgrade}
    end
  end


end
