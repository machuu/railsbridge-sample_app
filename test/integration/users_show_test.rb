require 'test_helper'

class UsersShowTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:test_admin_1)
    @user = users(:test_user_1)
    @another_user = users(:test_user_2)
  end

  test "should show activated user profile" do
    log_in_as(@user)
    get user_path(@another_user)
    assert_template 'users/show'
  end

  test "should redirect unactivated user profile" do
    log_in_as(@user)
    @another_user.update_attribute(:activated, false)
    get user_path(@another_user)
    assert_redirected_to root_url
    assert flash.present?
  end
end
