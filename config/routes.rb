Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  devise_for :users, controllers: {
    sessions:      "users/sessions",
    registrations: "users/registrations"
  }

  authenticated :user do
    root to: "dashboard#index", as: :authenticated_root
  end
  root to: redirect("/users/sign_in")

  resources :dashboard, only: [:index]

  resources :tasks do
    member { patch :update_status }
    resources :comments, only: [:create, :destroy]
  end

  resources :sectors
  
  scope "/team" do
    resources :users, only: [:new, :create,:index, :show, :edit, :update, :destroy], path: ""
  end

  resources :notifications, only: [:index] do
    collection { patch :mark_all_read }
    member     { patch :mark_read }
  end

  post "ai/suggest_tasks",    to: "ai#suggest_tasks",    as: :ai_suggest_tasks
  post "ai/analyze_workload", to: "ai#analyze_workload", as: :ai_analyze_workload
  get  "ai/daily_summary",    to: "ai#daily_summary",    as: :ai_daily_summary

  namespace :admin do
    root to: "dashboard#index"
    resources :companies
    resources :users
  end
  get  "profile",        to: "profile#show",  as: :profile
get  "profile/edit",   to: "profile#edit",  as: :edit_profile
patch "profile",       to: "profile#update", as: :update_profile
end