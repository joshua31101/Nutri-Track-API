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

  searchkick word: [:name]

  def search_data
    {
      name: name.downcase
    }
  end
end
