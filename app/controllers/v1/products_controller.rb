module V1
  class ProductsController < ApplicationController
    before_action :authorize_request
    before_action :find_user, only: [:scan_receipt]

    def show
      @product = Product.find(params[:id])
      render json: @product, status: :ok

      rescue Mongoid::Errors::DocumentNotFound
        respond_with_error('not_found')
    end

    private

    def find_user
      @user = User.find(params[:id])
      rescue Mongoid::Errors::DocumentNotFound
        respond_with_error('not_found')
    end

  end
end
