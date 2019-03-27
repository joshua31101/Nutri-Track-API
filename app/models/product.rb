class Product
  include Mongoid::Document
  has_many :nutrients

  searchkick

  field :ndb_number, type: Integer
  field :score, type: Float
  field :long_name, type: String
  field :data_source, type: String
  field :gtin_upc, type: Integer
  field :manufacturer, type: String
  field :ingredients_english, type: String

  embeds_many :nutrients

  def search_data
    {
      ndb_number: ndb_number,
      score: score,
      long_name: long_name,
      ingredients_english: ingredients_english
    }
  end
end
