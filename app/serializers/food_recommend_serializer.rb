class FoodRecommendSerializer < ActiveModel::Serializer
  attributes :id, :product_id, :recommended_product_ids
end
