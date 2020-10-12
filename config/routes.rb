Rails.application.routes.draw do
  resources :users
  post('/users/sign_in', to: 'users#sign_in')
  put('/users/:id', to: 'users#update')
  post('/users/sign_out/:id', to: 'users#sign_out')
end
