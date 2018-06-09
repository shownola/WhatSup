require 'test_helper'

class RecipesTest < ActionDispatch::IntegrationTest
  
  def setup
    @chef = Chef.create!(chefname: 'jackson', email: 'jackson@email.com', 
                      password: 'password', password_confirmation: 'password')
    @recipe = Recipe.create(name: 'Chicken Sautee', directions: 'Add onion and cook til clear', chef: @chef)
    @recipe2 = @chef.recipes.build(name: 'Fried Chicken', directions: 'Add flour')
    @recipe2.save
  end
  
  test 'should get recipes index' do
    get recipes_url
    assert_response :success
  end
  
  test 'should get recipes listing' do
    get recipes_path
    assert_template 'recipes/index'
    assert_select 'a[href=?]', recipe_path(@recipe), text: @recipe.name
    assert_select 'a[href=?]', recipe_path(@recipe2), text: @recipe2.name
  end
  
  test 'should get recipe show' do
    sign_in_as(@chef, 'password')
    get recipe_path(@recipe)
    assert_template 'recipes/show'
    assert_match @recipe.name.titleize, response.body
    assert_match @recipe.directions, response.body
    assert_match @chef.chefname, response.body
    assert_select 'a[href=?]', edit_recipe_path(@recipe), text: 'Edit this recipe'
    assert_select 'a[href=?]', recipe_path(@recipe), text: 'Delete this recipe'
    assert_select 'a[href=?]', recipes_path, text: 'Return to recipes'
  end
  
  test 'create new valid recipe' do
    sign_in_as(@chef, 'password')
    get new_recipe_path
    assert_template 'recipes/new'
    name_of_recipe = 'pepper chicken'
    directions_of_recipe = 'add pepper then cook for 5 minutes'
    assert_difference 'Recipe.count', 1 do
      post recipes_path, params: {recipe: { name: name_of_recipe, directions: directions_of_recipe } }
    end
    follow_redirect!
    assert_match name_of_recipe.titleize, response.body
    assert_match directions_of_recipe, response.body
  end
  
  test 'reject invalid recipe submissions' do
    sign_in_as(@chef, 'password')
    get new_recipe_path
    assert_template 'recipes/new'
    assert_no_difference 'Recipe.count' do
      post recipes_path, params: { recipe: { name: " ", directions: " " } }
    end
    assert_template 'recipes/new'
    assert_select 'h2.card-title'
    assert_select 'div.card-body'
  end
  
end


