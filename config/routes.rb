Rails.application.routes.draw do

  resources :events

  resources :users do
    get :logout, on: :collection
    post :login, on: :collection
    post :add_friend, on: :member
    delete :remove_friend, on: :member    
  end

  resources :invites

  resources :notifications, only: [:index, :destroy, :update]
  resources :friend_requests, controller: 'notifications', type: 'FriendRequest', only: [:index, :destroy, :update]
  resources :event_invites, controller: 'notifications', type: 'EventeInvite', only: [:index, :destroy, :update]
  resources :event_updates, controller: 'notifications', type: 'EventUpdates', only: [:index, :destroy, :update]
  resources :invite_rsvps, controller: 'notifications', type: 'InviteRSVPs', only: [:index, :destroy, :update]

  resources :events do
    # get ':param' => :show, on: :member
    # resources :invites
    get :chatlog, on: :member
    post :logchat, on: :member
    post :toggle_favorite, on: :member
    put :toggle_confirm, on: :member
    post :add_restaurant, on: :member
    get :foursquare, on: :member
  end

  root to: 'layouts#index'
end
