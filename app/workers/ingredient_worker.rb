class IngredientWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(product_ids)
    ingredient_ids = []
    Product.where(id: { :$in => product_ids }).each do |product|
      product.ingredients_english.split(',').each do |ing|
        ingredient = Ingredient.search(ing.gsub(/\W/,' ').strip.downcase, fields: [{name: :exact}])
        ingredient_ids << ingredient.first.id if ingredient.present?
      end
      product_ingredient = ProductIngredient.find_or_create_by(product_id: product.id)
      ProductIngredient.update(ingredient_ids: ingredient_ids)
      ingredient_ids = []
    end
  end
end
