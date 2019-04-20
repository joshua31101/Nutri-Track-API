module V1
  class ProductsController < ApplicationController
    before_action :authorize_request
    before_action :find_product, except: [:search]

    def show
      render json: @product, status: :ok
      rescue Mongoid::Errors::DocumentNotFound
        respond_with_error('not_found')
    end

    def find_serving_size
      @serving_size = ServingSize.where(NDB_No: @product.ndb_number).first
      render json: { serving_size: @serving_size }, status: :ok
    end

    def search
      # Searches up to 10 products whose long_name starts with the query
      @products = Product.search(params[:query], fields: [{long_name: :word_start}], limit: 10)
      # Perform asynchronous query job in the background
      IngredientWorker.perform_async(@products.map(&:to_s)) if @products.present?
      render json: { searched_products: @products }, status: :ok
    end

    private

    def find_product
      @product = Product.find(params[:id])
    end

  end
end
