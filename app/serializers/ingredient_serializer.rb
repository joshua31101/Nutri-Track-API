class IngredientSerializer < ActiveModel::Serializer
  attributes :id, :name, :alt_names, :desc, :additional_info, :found_in, :possible_health_effects, :allergy
end