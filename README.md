# Nutri-Track API

A Ruby on Rails API server communicating with the Nutri-Track front-end web app.

## How to run the server

1. Install Ruby (https://www.ruby-lang.org/en/documentation/installation/)
2. Install Rails (https://guides.rubyonrails.org/v5.0/getting_started.html#installing-rails)
3. Install and run Elasticsearch
```
brew install elasticsearch
brew services start elasticsearch
```
4. Install and run mongoDB (you will need to import the dataset beforehand)
5. Install and run Redis (https://redis.io/topics/quickstart)
6. Run `bundle install` to install libraries/gem
7. Run `rails server` to run the Rails server

## Core functionalities

### Persistent storage/models

- models: `app/models/[model_name].rb`

- MongoDB config: `config/mongoid.yml`

### Search

- Searching a product: `app/controllers/v1/products_controller.rb`

- Async job task: `app/workers/ingredient_worker.rb`

- Elasticsearch indexing: `app/models/product.rb#search_data`, `app/models/ingredient.rb#search_data`

- Scan of a grocery receipt: `app/controllers/v1/user_products_controller.rb#upload`

- Getting recommended foods: `app/controllers/v1/user_products_controller.rb#get_recommended_foods`

### Scripts

- Building food recommendations: `app/jobs/food_recommendation.rb`

- Calculating food score: `app/jobs/food_score_calculator.rb`

- Scrapping ingredients with grade, allergies, and possible health effects: `app/jobs/ingredient_scraper.rb`

### Routes

- API endpoints: `config/routes.rb`

```
POST   /auth/login(.:format)                          auth#login
GET    /v1/users/:user_id/products(.:format)          v1/user_products#index
DELETE /v1/users/:user_id/products/:id(.:format)      v1/user_products#destroy
GET    /v1/users(.:format)                            v1/users#index
POST   /v1/users(.:format)                            v1/users#create
GET    /v1/users/:id(.:format)                        v1/users#show
PATCH  /v1/users/:id(.:format)                        v1/users#update
PUT    /v1/users/:id(.:format)                        v1/users#update
DELETE /v1/users/:id(.:format)                        v1/users#destroy
POST   /v1/users/:user_id/upload-receipt(.:format)    v1/user_products#upload
POST   /v1/users/:user_id/products/:id(.:format)      v1/user_products#add
GET    /v1/products/:id(.:format)                     v1/products#show
GET    /v1/search-products(.:format)                  v1/products#search
GET    /v1/products/:id/serving-size(.:format)        v1/products#find_serving_size
GET    /v1/products/:id/ingredients(.:format)         v1/product_ingredients#show
GET    /v1/users/:user_id/recommended-foods(.:format) v1/user_products#get_recommended_foods
GET    /v1/users/:user_id/product-recipes(.:format)   v1/user_products#get_recipes
```
