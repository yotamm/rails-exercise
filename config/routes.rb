Rails.application.routes.draw do
  resources :users
  post('/users/sign_in', to: 'users#sign_in')
  put('/users/update', to: 'users#update')
end
