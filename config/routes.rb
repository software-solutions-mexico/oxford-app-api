Rails.application.routes.draw do
  devise_for :users, controllers: {
      sessions:      'v1/sessions'
  }
  namespace :v1, defaults: { format: :json } do
    resources :sessions, only: [:show, :create, :destroy]
    resources :users, only:[:create]
    resources :kids, only:[:create]
  end
end
