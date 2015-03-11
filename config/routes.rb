Rails.application.routes.draw do

  resources :events

  resources :users do
    get :logout, on: :collection
    post :login, on: :collection
    post :add_friend, on: :collection
    delete :remove_friend, on: :collection
    resources :notifications, only: [:index, :destroy, :update]
  end

  root to: 'users#index'
end
