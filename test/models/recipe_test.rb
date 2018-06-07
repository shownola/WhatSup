require 'test_helper'

class RecipeTest < ActiveSupport::TestCase
  
  def setup
    @recipe = Recipe.new(name: 'chicken', directions: 'stir and cook')
  end
  
  test 'should be valid' do
    assert @recipe.valid?
  end
  
  test 'name should be present' do
    @recipe.name = " "
    assert_not @recipe.valid?
  end
  
  test 'directions should be present' do
    @recipe.directions = " "
    assert_not @recipe.valid?
  end
  
  test 'directions should not be less than 5 characters' do
    @recipe.directions = 'a' * 3
    assert_not @recipe.valid?
  end
  
  test 'directions should not be more than 1000 characters' do
    @recipe.directions = 'a' * 1001
    assert_not @recipe.valid?
  end
  
  
end