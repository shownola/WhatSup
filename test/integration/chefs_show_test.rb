require 'test_helper'

class ChefsShowTest < ActionDispatch::IntegrationTest
 
 def setup
   @chef = Chef.create!(chefname: 'jackson', email: 'jackson@email.com', 
                      password: 'password', password_confirmation: 'password')
    @recipe = Recipe.create(name: 'Chicken Sautee', directions: 'Add onion and cook til clear', chef: @chef)
    @recipe2 = @chef.recipes.build(name: 'Fried Chicken', directions: 'Add flour')
    @recipe2.save
 end
 
 test 'should get chefs show' do
   get chef_path(@chef)
   assert_template 'chefs/show'
   assert_select 'a[href=?]', recipe_path(@recipe), text: @recipe.name
   assert_select 'a[href=?]', recipe_path(@recipe2), text: @recipe2.name
   assert_match @recipe.directions, response.body
   assert_match @recipe2.directions, response.body
   assert_match @chef.chefname, response.body
 end
end
