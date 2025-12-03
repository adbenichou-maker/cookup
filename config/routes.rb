Rails.application.routes.draw do
  devise_for :users

  root to: "pages#home"

  get "/dashboard", to: "pages#dashboard"
  get "/recipes/search", to: "recipes#search", as: :recipes_search

  resources :recipes, only: [:index, :show, :create] do
    member do
      get :completed
    end
    resources :steps, only: [:index]
    resources :reviews, only: [:new, :create]
    resources :user_recipes, only: [:create]
  end

  resources :user_recipes, only: [:destroy] #not priority

  # resources :recipes, only: []

  resources :skills, only: [:index, :show] do
    resources :user_skills, only: [:create]
  end

  resources :chats, only: [:index, :new, :show, :create] do
    resources :messages, only: [:create]
  end

end
