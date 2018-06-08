require 'test_helper'

class ChefsEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @chef = Chef.create!(chefname: 'jackson', email: 'jackson@email.com',
            password: 'password', password_confirmation: 'password')
    @recipe = Recipe.create(name: 'Chicken Sautee', directions: 'Add onion and cook til clear', chef: @chef)
  end
  
  test 'reject an invalid edit' do
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { chef: { chefname: " ", email: "jackson@email.com" } }
    assert_template 'chefs/edit'
    assert_select 'h2.card-title'
    assert_select 'div.card-body'
  end
  
  test 'accept valid edit' do
   
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { chef: { chefname: "jackson1", email: "jackson1@email.com" } }
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match 'jackson1', @chef.chefname
    assert_match 'jackson1@email.com', @chef.email
  end
end


