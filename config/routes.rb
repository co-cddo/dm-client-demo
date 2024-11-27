Rails.application.routes.draw do
  resources :users
  devise_for(
    :user,
    controllers: { omniauth_callbacks: "users/omniauth_callbacks" },
  )

  resources :records do
    member do
      post :publish
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index"
end
