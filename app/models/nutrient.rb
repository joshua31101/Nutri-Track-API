class Nutrient
	include Mongoid::Document

	field :NDB_Number, type: Integer
	field :code, type: Integer
	field :name, type: String
	field :deriv_code, type: String
	field :value, type: Float
	field :unit, type: String

	embedded_in :product
end
