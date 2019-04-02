class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :products_ids
end
