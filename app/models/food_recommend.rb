class FoodRecommend
  include Mongoid::Document

  field :product_id, type: String
  field :_id, type: String, default: -> { product_id }
  field :recommended_product_ids, type: Array
end
