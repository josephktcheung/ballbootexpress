class Size < ActiveRecord::Base
  has_many :available_sizes
  has_many :products, through: :available_sizes
end
