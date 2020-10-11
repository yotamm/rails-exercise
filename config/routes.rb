Rails.application.routes.draw do
  resources :users
  post('/users/sign_in', to: 'users#sign_in')
end
