Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope 'v1' do
    post '/auth/login', to: 'auth#login'
    resources :users
  end
end
