class Nutrient
	include Mongoid::Document
	belongs_to :product

	field :NDB_No, type: Integer
	field :Nutrient_Code, type: Integer
	field :Nutrient_name, type: String
	field :Derivation_Code, type: String
	field :Output_value, type: Float
	field :Output_uom, type: String

	embedded_in :product
end
