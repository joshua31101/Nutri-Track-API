class Ingredient
  include Mongoid::Document

  field :name, type: String
  field :alt_names, type: String
  field :desc, type: String
  field :additional_info, type: String
  field :found_in, type: String
  field :possible_health_effects, type: String
  field :allergy, type: String
  field :grade, type: String

  # Define Elasticsearch word matching for name field
  searchkick word: [:name]

  # Elasticsearch properties to be indexed
  def search_data
    {
      name: name.downcase
    }
  end
end
