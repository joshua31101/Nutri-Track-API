class Code
  include Mongoid::Document

  field :code, type: String
  field :desc, type: String
end
