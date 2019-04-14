class FoodRecommendation < ActiveJob::Base
  def perform
    count = 0
    total_count = Product.count
    p 'Create recommended food list'
    i = total_count - 1
    Product.all[107338..i].each do |product|
      recommended_product_ids = product.similar.to_a.select { |p| p.score >= product.score }.map(&:id)
      food_recommend = FoodRecommend.find_or_create_by(product_id: product.id)
      food_recommend.update(
        product_id: product.id,
        recommended_product_ids: recommended_product_ids
      )
      p "#{count += 1}/#{total_count}: recommended product count => #{recommended_product_ids.count}"
    end
    p 'Finished!'
  end
end
