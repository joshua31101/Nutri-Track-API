class Product
  include Mongoid::Document
  has_many :user_products
  has_many :nutrients

  # Define Elasticsearch word_start matching for long_name field
  searchkick word_start: [:long_name]

  field :ndb_number, type: Integer
  field :score, type: Float
  field :long_name, type: String
  field :data_source, type: String
  field :gtin_upc, type: Integer
  field :manufacturer, type: String
  field :ingredients_english, type: String

  embeds_many :nutrients

  # Elasticsearch properties to be indexed
  def search_data
    {
      ndb_number: ndb_number,
      score: score,
      long_name: long_name,
      ingredients_english: ingredients_english
    }
  end
end
