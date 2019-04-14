Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post '/auth/login', to: 'auth#login'

  namespace 'v1' do
    resources :users do
      resources :user_products, path: 'products', except: [:new, :update, :edit]
    end

    post '/users/:user_id/upload-receipt', to: 'user_products#upload'
    get '/products/:id', to: 'products#show'
    get '/products/:id/serving-size', to: 'products#find_serving_size'
    get '/products/:id/ingredients', to: 'product_ingredients#show'
    get '/users/:user_id/recommended-foods', to: 'user_products#get_recommended_foods'
  end
end
