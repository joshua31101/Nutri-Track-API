class ServingSizeSerializer < ActiveModel::Serializer
  attributes :id, :NDB_No, :Serving_Size, :Serving_Size_UOM, :Household_Serving_Size, :Household_Serving_Size_UOM, :Preparation_State
end
