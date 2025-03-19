Rails.application.routes.draw do
  # Staff authentication routes
  devise_for :staffs, controllers: { sessions: 'staffs/sessions' }
  
  devise_scope :staff do
    get 'staffs/otp', to: 'staffs/otp#new', as: :staff_otp
    post 'staffs/otp', to: 'staffs/otp#create'
  end
  
  # Customer data management
  resources :customers, only: [:index, :show] do
    collection do
      post :upload_csv
    end
  end
  
  # Order management for staff
  resources :orders, only: [:index, :show, :update]
  
  # Reservation management for staff
  resources :reservations, only: [:index, :show, :update]
  
  # API routes for customer-facing app
  namespace :api do
    namespace :v1 do
      resources :orders, only: [:create, :index, :show]
      resources :reservations, only: [:create, :index]
      resources :menu_items, only: [:index]
    end
  end
  
  # Dashboard
  root to: 'dashboard#index'
end