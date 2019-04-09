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
      ProductIngredient.create(product_id: product.id, ingredient_ids: ingredient_ids)
      ingredient_ids = []
    end
  end
end
