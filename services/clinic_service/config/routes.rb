Rails.application.routes.draw do
  namespace :oauth do
    get :login, to: "sessions#create"
    get :callback, to: "sessions#callback"
  end
  resources :clinics

  get "up" => "rails/health#show", as: :rails_health_check

  root "clinics#index"
end