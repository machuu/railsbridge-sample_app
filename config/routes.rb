Rails.application.routes.draw do
  # Static Pages Routes
  root 'static_pages#home'
  get '/help',    to: 'static_pages#help'
  get '/about',   to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'

  # User Routes
  resources :users
  get   '/signup', to: 'users#new'
  post  '/signup', to: 'users#create'

  # Sessions Routes
  get     '/login',   to: 'sessions#new'
  post    '/login',   to: 'sessions#create'
  delete  '/logout',  to: 'sessions#destroy'

  # Account Activations Routes
  resources :account_activations, only: [:edit]

  # Password Resets Routes
  resources :password_resets, only: [:new, :create, :edit, :update]

  # Microposts Routes
  resources :microposts, only: [:create, :destroy]
end
