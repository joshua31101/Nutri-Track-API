class ProductIngredient
  include Mongoid::Document

  field :product_id, type: String
  field :_id, type: String, default: -> { product_id }
  field :ingredient_ids, type: Array
end
