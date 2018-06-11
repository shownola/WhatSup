class RecipeIngredient < ApplicationRecord
  belongs_to :ingredient, optional: true
  belongs_to :recipe, optional: true
  
  accepts_nested_attributes_for :recipe
  accepts_nested_attributes_for :ingredient
  
  
end