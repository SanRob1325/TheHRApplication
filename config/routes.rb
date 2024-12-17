Rails.application.routes.draw do
  resources :notifications, only: [:index, :create,:destroy]
  resources :attendances
  resources :departments
  resources :employees
  resources :leave_requests
  resources :performance_reviews, only: [:index, :create,:update, :destroy]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :leave_requests do
    member do
      patch :change_status
    end
  end
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
