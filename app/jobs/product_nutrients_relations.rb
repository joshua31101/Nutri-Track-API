class ProductNutrientsRelations < ActiveJob::Base
  def perform
    require 'csv'

    p_count = Product.count
    p = Product.first
    nutrients = []
    i = 0
    CSV.foreach("#{Rails.root}/dataset/BFPD_csv/Nutrients.csv", headers: true) do |row|
      ndb_no = row[0].to_i
      val = row[4].to_f
      code = row[1].to_i
      n = Nutrient.new(
        NDB_Number: ndb_no,
        code: code,
        name: row[2],
        deriv_code: row[3],
        value: val,
        unit: row[5]
      )

      if p.NDB_Number == ndb_no
        nutrients << n
      else
        p.update({
          score: 0.710 - 0.0538 * total_fat - 0.423 * sat_fat - 0.00398 * cholesterol -
            0.00254 * sodium - 0.0300 * total_carb + 0.561 * fiber - 0.0245 * sugars + 0.123 * 
            protein + 0.00562 * vit_a + 0.0137 * vit_c + 0.0685 * cal - 0.0186 * iron,
          nutrients: nutrients
        })
        p = Product.where(NDB_Number: ndb_no)[0]
        nutrients = [n]

        p "#{i += 1}/#{p_count}"
      end
    end

  end
end
