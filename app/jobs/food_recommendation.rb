class FoodRecommendation < ActiveJob::Base
  def perform
    count = 0
    total_count = Product.count - 1
    p 'Create recommended food list'
    Product.all[0..total_count].each do |product|
      recommended_product_ids = product.similar.to_a.select { |p| p.score >= product.score }.map(&:id)
      food_recommend = FoodRecommend.find_or_create_by(product_id: product.id)
      food_recommend.update(recommended_product_ids: recommended_product_ids)
      p "#{count += 1}/#{total_count}: recommended product count => #{recommended_product_ids.count}"
    end
    p 'Finished!'
  end
end
