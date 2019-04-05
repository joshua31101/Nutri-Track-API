class UserProduct
  include Mongoid::Document
  belongs_to :user
  belongs_to :product

  field :user_id, type: String
  field :product_id, type: String
  field :purchase_date, type: DateTime
  field :count, type: Integer
end
