class Recipe < ApplicationRecord
  validates :name, presence: true
  validates :directions, presence: true, length: {minimum: 5, maximum: 1000 }
  
end