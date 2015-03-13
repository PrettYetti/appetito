Rails.application.routes.draw do

  get 'invite/index'

  get 'invite/show'

  get 'invite/create'

  get 'invite/update'

  get 'invite/destroy'

  resources :events

  resources :users do
    get :logout, on: :collection
    post :login, on: :collection
    post :add_friend, on: :collection
    delete :remove_friend, on: :collection
    
  end

  resources :invites

  resources :notifications, only: [:index, :destroy, :update]
  resources :friend_requests, controller: 'notifications', type: 'FriendRequest', only: [:index, :destroy, :update]
  resources :event_invites, controller: 'notifications', type: 'EventeInvite', only: [:index, :destroy, :update]
  resources :event_updates, controller: 'notifications', type: 'EventUpdates', only: [:index, :destroy, :update]
  resources :invite_rsvps, controller: 'notifications', type: 'InviteRSVPs', only: [:index, :destroy, :update]

  resources :events do
    # get ':param' => :show, on: :member
    resources :invites
    get :chatlog, on: :member
  end

  root to: 'layouts#index'
end
