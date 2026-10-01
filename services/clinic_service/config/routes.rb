Rails.application.routes.draw do
  resources :clinics

  get "up" => "rails/health#show", as: :rails_health_check

  root "clinics#index"
end