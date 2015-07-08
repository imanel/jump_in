Rails.application.routes.draw do

  root 'welcome#index'
  get '/signup' => 'users#new'
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'
  resources :users
  resource :password_resets, except: [:index, :destroy, :show]
end
