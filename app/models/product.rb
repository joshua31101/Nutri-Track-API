class Product
  include Mongoid::Document
  has_many :nutrients

  field :NDB_Number, type: Integer
  field :score, type: Float
  field :long_name, type: String
  field :data_source, type: String
  field :gtin_upc, type: Integer
  field :manufacturer, type: String
  field :date_modified, type: DateTime
  field :date_available, type: DateTime
  field :ingredients_english, type: String

  embeds_many :nutrients
end
