class FoodScoreCalculator < ActiveJob::Base
  def perform
    p_count = Product.count
    i = 0
    Product.all.each do |p|
      protein = 0
      sat_fat = 0
      total_fat = 0
      sugars = 0
      fiber = 0
      total_carb = 0
      cholesterol = 0
      sodium = 0
      vit_a = 0
      vit_c = 0
      cal = 0
      iron = 0
      p.nutrients.each do |n|
        case n.code
        when 203
          protein = n.value
        when 606
          sat_fat = n.value
        when 204
          total_fat = n.value
        when 269
          sugars = n.value
        when 291
          fiber = n.value
        when 205
          total_carb = n.value
        when 601
          cholesterol = n.value
        when 307
          sodium = n.value
        when 318
          vit_a = n.value / 50 # daily value of 5000 IU in percent
        when 401
          vit_c = n.value / 0.6 # daily vlaue of 60mg in percent
        when 301
          cal = n.value / 10 # daily vlaue of 1000mg in percent
        when 303
          iron = n.value / 0.18 # daily vlaue of 18mg in percent
        end
      end

      p.update(score: 0.710 - 0.0538 * total_fat - 0.423 * sat_fat - 0.00398 * cholesterol -
        0.00254 * sodium - 0.0300 * total_carb + 0.561 * fiber - 0.0245 * sugars + 0.123 * 
        protein + 0.00562 * vit_a + 0.0137 * vit_c + 0.0685 * cal - 0.0186 * iron
      )
      p "#{i += 1}/#{p_count}"
    end
  end
end
