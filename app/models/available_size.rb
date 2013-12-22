class AvailableSize < ActiveRecord::Base
  belongs_to :product
  belongs_to :size
end
