module V1
  class ProductIngredientsController < ApplicationController
    before_action :authorize_request
    before_action :find_product

    def show
      @ingredients = []
      @product.ingredients_english.split(',').each do |ing|
        ingredient = Ingredient.search(ing.gsub(/\W/,' ').strip.downcase, fields: [{name: :exact}])
        @ingredients << ingredient.first if ingredient.present?
      end

      render json: { ingredients: @ingredients }, status: :ok
    end

    private

    def find_product
      @product = Product.find(params[:id])
    end

  end
end
