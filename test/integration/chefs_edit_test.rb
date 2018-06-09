require 'test_helper'

class ChefsEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @chef = Chef.create!(chefname: 'jackson', email: 'jackson@email.com',
            password: 'password', password_confirmation: 'password')
    @chef2 = Chef.create!(chefname: 'jackson1', email: 'jackson1@email.com', 
                      password: 'password', password_confirmation: 'password')
    @admin_user = Chef.create!(chefname: 'jackson2', email: 'jackson2@email.com',
                      password: 'password', password_confirmation: 'password', 
                      admin: true)
    @recipe = Recipe.create(name: 'Chicken Sautee', directions: 'Add onion and cook til clear', chef: @chef)
  end
  
  test 'reject an invalid edit' do
    sign_in_as(@chef, 'password')
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { chef: { chefname: " ", email: "jackson@email.com" } }
    assert_template 'chefs/edit'
    assert_select 'h2.card-title'
    assert_select 'div.card-body'
  end
  
  test 'accept valid edit' do
    sign_in_as(@chef, 'password')
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { chef: { chefname: "jackson1", email: "jackson1@email.com" } }
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match 'jackson1', @chef.chefname
    assert_match 'jackson1@email.com', @chef.email
  end
  
  test 'accept edit attempt by admin user' do
    sign_in_as(@admin_user, 'password')
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { chef: { chefname: "jackson3", email: "jackson3@email.com" } }
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match 'jackson3', @chef.chefname
    assert_match 'jackson3@email.com', @chef.email
  end
  
  test 'redirect edit attempt by another non-admin user' do
    sign_in_as(@chef2, 'password')
    updated_name = 'joe'
    updated_email = 'joe@email.com'
    patch chef_path(@chef), params: { chef: { chefname: updated_name, email: updated_email } }
    assert_redirected_to chefs_path
    assert_not flash.empty?
    @chef.reload
    assert_match 'jackson', @chef.chefname
    assert_match 'jackson@email.com', @chef.email
  end
end



