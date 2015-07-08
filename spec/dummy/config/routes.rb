Rails.application.routes.draw do

  root 'welcome#index'
  get '/signup' => 'users#new'
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'
  get '/reset_password' => 'users#reset_password'
  resources :users
  resources :password_resets, except: [:index, :destroy, :show]
end
