Rails.application.routes.draw do
  # devise_for :users
  namespace :v1 do
    resources :sessions, only: [:create, :destroy]
  end
end
