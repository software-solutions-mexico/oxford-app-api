Rails.application.routes.draw do
  devise_for :users, controllers: {
      sessions: 'v1/sessions'
  }
  namespace :v1, defaults: { format: :json } do
    resources :sessions, only: [:create, :show, :destroy]
    resources :users, only:[:index, :create, :update]
    resources :kids, only:[:index, :create, :show, :update]
    get 'kids/by_family_key/:family_key', to: 'kids#show_by_family_key'
    post 'kids/create_kids_from_xls', to: 'kids#import_data_from_excel'
    post 'users/create_users_from_xls', to: 'users#import_data_from_excel'
  end
end
