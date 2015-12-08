Rails.application.routes.draw do
  root 'users#index'

devise_for :users
  get '/users' => 'users#index', as: 'users'
  get '/users/:id/' => 'users#profile'


  post '/api/service' => 'api#service'

end
