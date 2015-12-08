Rails.application.routes.draw do
  root 'users#index'

  get '/users/:id/' => 'users#profile'
  get '/users' => 'users#index', as: 'users'
  devise_for :users

  post '/api/service' => 'api#service'

end
