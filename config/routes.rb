Rails.application.routes.draw do

  resources :events

  resources :users do
    get :logout, on: :collection
    post :login, on: :collection
  end

  root to: 'users#index'
end
