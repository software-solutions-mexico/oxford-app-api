Rails.application.routes.draw do
  devise_for :users, controllers: {
      sessions: 'v1/sessions'
  }
  namespace :v1, defaults: { format: :json } do
    resources :sessions, only: [:create, :show, :destroy]
    resources :users, only:[:index, :create, :update]
    resources :kids, only:[:index, :create, :show, :update]
    get 'kids/by_family_key/:family_key', to: 'kids#show_by_family_key'
  end
end
