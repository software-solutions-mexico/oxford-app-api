Rails.application.routes.draw do
  devise_for :users, controllers: {
      sessions: 'v1/sessions'
  }
  namespace :v1, defaults: { format: :json } do
    resources :sessions, only: [:create, :show, :destroy]
    resources :users, only:[:index, :create, :update]
    resources :kids, only:[:index, :create, :show, :update]
  end
end
