class ServingSize
  include Mongoid::Document

  field :NDB_No, type: Integer
  field :Serving_Size, type: Float
  field :Serving_Size_UOM, type: String
  field :Household_Serving_Size, type: Float
  field :Household_Serving_Size_UOM, type: String
  field :Preparation_State, type: String
end
