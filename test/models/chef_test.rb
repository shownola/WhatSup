require 'test_helper'

class ChefTest < ActiveSupport::TestCase
  
  def setup
    @chef = Chef.new(chefname: 'jackson', email: 'jackson@email.com',
                      password: 'password', password_confirmation: 'password')
  end
  
  test 'should be valid' do
    assert @chef.valid?
  end
  
  test 'chefname should be present' do
    @chef.chefname = " "
    assert_not @chef.valid?
  end
  
  test 'chefname should be less than 30 characters' do
    @chef.chefname = 'a' * 31
    assert_not @chef.valid?
  end
  
  test 'email should be present' do
    @chef.email = " "
    assert_not @chef.valid?
  end
  
  test 'email should be less than 255 characters' do
    @chef.email = 'a' * 245 + '@example.com'
    assert_not @chef.valid?
  end
  
  test 'email should accept correct format' do
    valid_emails = %w[user@example.com JACKSON@gmail.com A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_emails.each do |valids| 
      @chef.email = valids
      assert @chef.valid?, "#{valids.inspect} should be valid"
    end
  end
  
  test 'should reject invalid emails' do
    invalid_emails = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_emails.each do |invalids|
      @chef.email = invalids
      assert_not @chef.valid?, "#{invalids.inspect} should be invalid"
    end
  end
  
  test 'email should be unique and case insensitive' do
    duplicate_chef = @chef.dup
    duplicate_chef.email = @chef.email.upcase
    @chef.save
    assert_not duplicate_chef.valid?
  end
  
  test 'email should be lowercase before hitting the database' do
    mixed_email = 'JohN@ExampLe.com'
    @chef.email = mixed_email
    @chef.save
    assert_equal mixed_email.downcase, @chef.reload.email
  end
  
  test 'password should be present' do
    @chef.password = @chef.password_confirmation = " "
    assert_not @chef.valid?
  end
  
  test 'password should be at least 5 characters' do
    @chef.password = @chef.password_confirmation = 'a' * 4
    assert_not @chef.valid?
  end
  
  test 'associated recipes deleted when chef is deleted' do
    @chef.save
    @chef.recipes.create!(name: 'test recipe', directions: 'test directions')
    assert_difference 'Recipe.count', -1 do
      @chef.destroy 
    end
  end
  
  
  
 
  
end
  
 
  
 
  
  
