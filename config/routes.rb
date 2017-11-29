Rails.application.routes.draw do
  devise_for :users

  root to: 'events#index'
  resources :events, only: [:show, :index]

  namespace :api do
    namespace :local do
      resources :event_notifications, only: [] do
        patch :make_seen, on: :collection, as: :make_seen
      end
      resources :events, only: [:index]
      resources :filters, only: [] do
        post :create_or_update, on: :collection
      end
    end
  end
end
