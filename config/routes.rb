Rails.application.routes.draw do

  resources :events

  resources :users do
    get :logout, on: :collection
    post :login, on: :collection
    post :add_friend, on: :collection
    delete :remove_friend, on: :collection
  end

  root to: 'users#index'
end
