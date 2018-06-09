require 'test_helper'

class RecipesEditTest < ActionDispatch::IntegrationTest
 
 def setup
    @chef = Chef.create!(chefname: 'jackson', email: 'jackson@email.com',
            password: 'password', password_confirmation: 'password')
    @recipe = Recipe.create(name: 'Chicken Sautee', directions: 'Add onion and cook til clear', chef: @chef)
 end
 
 test 'reject invalid recipe update' do
  sign_in_as(@chef, 'password')
   get edit_recipe_path(@recipe)
   assert_template 'recipes/edit'
   patch recipe_path(@recipe), params: { recipe: { name: " ", directions: "some directions" } }
   assert_template 'recipes/edit'
   assert_select 'h2.card-title'
   assert_select 'div.card-body'
 end
 
 test 'successfully edit a recipe' do
  sign_in_as(@chef, 'password')
   get edit_recipe_path(@recipe)
   assert_template 'recipes/edit'
   updated_name = 'updated recipe name'
   updated_directions = 'directions have been updated'
   patch recipe_path(@recipe), params: { recipe: { name: updated_name, directions: updated_directions } }
  # follow_redirect!
   assert_redirected_to @recipe
   assert_not flash.empty?
   @recipe.reload
   assert_match updated_name, @recipe.name
   assert_match updated_directions, @recipe.directions
 end
 
end
