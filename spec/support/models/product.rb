class Product
  include Mongoid::Document
  include Mongoid::Timestamps
  include Manganese::Tenancy

  field :sku,  type: String
  field :name, type: String

  belongs_to :company

end
