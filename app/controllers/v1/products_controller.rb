module V1
  class ProductsController < ApplicationController
    before_action :authorize_request
    before_action :find_product

    def show
      render json: @product, status: :ok
      rescue Mongoid::Errors::DocumentNotFound
        respond_with_error('not_found')
    end

    def find_serving_size
      @serving_size = ServingSize.where(NDB_No: @product.ndb_number).first
      render json: { serving_size: @serving_size }, status: :ok
    end

    private

    def find_product
      @product = Product.find(params[:id])
    end

  end
end
