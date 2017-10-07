require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:test_user_1)
    @another_user = users(:test_user_2)
  end

  test "should get signup" do
    get signup_path
    assert_response :success
  end

  test "should redirect edit page to login when not logged in" do
    get edit_user_path(@user)
    assert flash.present?
    assert_redirected_to login_url
  end

  test "should redirect update page to login when not logged in" do
    patch user_path(@user), params: {
                              user: {
                                name: @user.name,
                                email: @user.email }  }
    assert flash.present?
    assert_redirected_to login_url
  end

  test "should redirect edit page when logged in another user" do
    log_in_as(@another_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update page when logged in another user" do
    log_in_as(@another_user)
    patch user_path(@user), params: {
                              user: {
                                name: @user.name,
                                email: @user.email }  }
    assert flash.empty?
    assert_redirected_to root_url
  end
end
