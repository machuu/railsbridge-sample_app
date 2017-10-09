require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:test_admin_1)
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

  test "should redirect index page to login when not logged in" do
    get users_path
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

  test "should not allow the admin attribute to be edited via the wweb" do
    log_in_as(@another_user)
    assert_not @another_user.admin?
    patch user_path(@another_user), params: {
                                    user: { password: 'password',
                                            password_confirmation: 'password',
                                            admin: true } }
    assert_not @another_user.reload.admin?
  end

  test "should redirect destroy action when logged in as non-admin" do
    log_in_as(@user)
    assert_no_difference 'User.count' do
      delete user_path(@another_user)
    end
    assert_redirected_to root_url
  end

  test "should perform destroy action when logged in as admin" do
    log_in_as(@admin)
    assert_difference 'User.count', -1 do
      delete user_path(@another_user)
    end
  end
end
