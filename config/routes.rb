Rails.application.routes.draw do
  get "about", to: "static_pages#about", as: :about

  resources :pokemons, only: [ :index, :show ]

  get "up" => "rails/health#show", as: :rails_health_check

  root "static_pages#home"
end
