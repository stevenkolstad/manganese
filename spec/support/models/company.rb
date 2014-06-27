class Company
  include Mongoid::Document
  include Mongoid::Timestamps
  include Manganese::Tenant

  field :name,    type: String
  field :status,  type: String, default: 'inactive'
  field :domains, type: Array

  has_many :products

end
