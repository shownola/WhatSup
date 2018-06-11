class Recipe < ApplicationRecord
  validates :name, presence: true
  validates :directions, presence: true, length: {minimum: 5, maximum: 1000 }
  
  belongs_to :chef
  validates :chef_id, presence: true
  default_scope -> { order(updated_at: :DESC) }
  has_many :recipe_ingredients, inverse_of: :recipe, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients
  has_many :comments, dependent: :destroy
  
  accepts_nested_attributes_for :ingredients, :recipe_ingredients, allow_destroy: true, reject_if: proc { |attributes| attributes['name'].blank? }
  
  
  
end