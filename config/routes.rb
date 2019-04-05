Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post '/auth/login', to: 'auth#login'

  namespace 'v1' do
    resources :users do
      resources :user_products, path: 'products', except: [:new, :update, :edit]
    end
    post '/users/:user_id/upload-receipt', to: 'user_products#upload'
    get '/products/:id', to: 'products#show'
  end
end
