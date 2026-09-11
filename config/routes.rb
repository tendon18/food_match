Rails.application.routes.draw do
  root "users#new"

  resources :users, only: [ :new, :create ]
  resource :session, only: [ :new, :create, :destroy ]

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
