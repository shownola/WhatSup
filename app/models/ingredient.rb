class Ingredient < ApplicationRecord
  validates :name, presence: true, length: { minimum: 2, maximum: 35 }
  validates_uniqueness_of :name
  has_many :recipe_ingredients, inverse_of: :ingredients
  has_many :recipes, through: :recipe_ingredients
  default_scope -> { order(name: :ASC) }
  
  accepts_nested_attributes_for :recipe_ingredients
  accepts_nested_attributes_for :recipes
 
end

