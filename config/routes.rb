# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope "/api" do
    post "users", to: "users#create"
    get "user", to: "users#index"
    put "user", to: "users#update"
    post "users/login", to: "users#login"
    get "profiles/:username", to: "users#show"
    post "profiles/:username/follow", to: "users#follow"
    delete "profiles/:username/follow", to: "users#unfollow"

    resources :tags, only: :index

    resources :articles, param: :slug do
      collection do
        get "feed"
      end
      member do
        post "favorite"
        delete "favorite", action: :unfavorite
        resources :comments, only: %i[index create destroy]
      end
    end
  end
end
