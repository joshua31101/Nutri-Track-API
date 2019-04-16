module V1
  class ProductIngredientsController < ApplicationController
    before_action :authorize_request
    before_action :find_product

    def show
      @ingredients = []
      product_ingredient = ProductIngredient.where(id: @product.id).first
      if product_ingredient.present? && product_ingredient.ingredient_ids.present?
        # ingredients exist from async worker successfully ran after receipt upload
        @ingredients = Ingredient.find(product_ingredient.ingredient_ids)
      else
        # no ingredients are found in product_ingredient object generated from async worker
        @product.ingredients_english.split(',').each do |ing|
          ingredient = Ingredient.search(ing.gsub(/\W/,' ').strip.downcase, fields: [{name: :exact}])
          @ingredients << ingredient.first if ingredient.present?
        end
        productIngredient = ProductIngredient.find_or_create_by(product_id: @product.id)
        productIngredient.update(ingredient_ids: @ingredients.map(&:id))
      end
      render json: { ingredients: @ingredients }, status: :ok
    end

    private

    def find_product
      @product = Product.find(params[:id])
    end

  end
end
