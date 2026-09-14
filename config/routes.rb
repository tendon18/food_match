Rails.application.routes.draw do
  get "home/top"
  root "home#top"

  resources :users, only: [ :new, :create ]
  resource :session, only: [ :new, :create, :destroy ]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :groups, only: [:index, :new, :create, :show]

  get "/groups/:group_id/conditions/area",
    to: "group_conditions#area",
    as: :group_conditions_area

  post "/groups/:group_id/conditions/area",
    to: "group_conditions#save_area",
    as: :save_group_conditions_area

  get "/groups/:group_id/conditions/genre",
    to: "group_conditions#genre",
    as: :group_conditions_genre

  post "/groups/:group_id/conditions/genre",
    to: "group_conditions#save_genre",
    as: :save_group_conditions_genre

  get "/groups/:group_id/conditions/budget",
    to: "group_conditions#budget",
    as: :group_conditions_budget

  post "/groups/:group_id/conditions/budget",
    to: "group_conditions#save_budget",
    as: :save_group_conditions_budget

  get "/groups/:group_id/conditions/ng",
    to: "group_conditions#ng",
    as: :group_conditions_ng

  post "/groups/:group_id/conditions/ng",
    to: "group_conditions#save_ng",
    as: :save_group_conditions_ng

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
