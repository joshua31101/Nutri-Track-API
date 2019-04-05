class ProductSerializer < ActiveModel::Serializer
  attributes :id, :ndb_number, :score, :long_name, :data_source, :gtin_upc, :manufacturer, :ingredients_english
end
