class Product < ActiveRecord::Base
  
  #validates_attachment :image, presence: true,
 #                             content_type: { content_type: ['image/jpeg', 'image/jpg', 'image/png', 'image/gif']},
  #                             size: { less_than: 5.megabytes }

  belongs_to :type
  belongs_to :brand
  has_attached_file :image
  has_many :available_sizes
  has_many :sizes, through: :available_sizes
end
