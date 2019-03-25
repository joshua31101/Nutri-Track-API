class User
  include Mongoid::Document
  include ActiveModel::SecurePassword

  field :email, type: String
  field :password_digest, type: String
  field :products_ids, type: Array

  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password_digest, length: { minimum: 8 }, if: -> { new_record? || !password.nil? }
end
