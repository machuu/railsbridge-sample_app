require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup - all fields invalid" do
    get signup_path
    assert_no_difference 'User.count' do
      post signup_path, params: { user: { name: "",
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'form[action="/users"]'
  end

  test "invalid signup - blank password" do
    get signup_path
    assert_no_difference 'User.count' do
      post signup_path, params: { user: { name: "Example User",
                                         email: "user@example.com",
                                         password:              "",
                                         password_confirmation: "" } }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'form[action="/users"]'
  end

  test "valid signup" do
    get signup_path
    assert_difference 'User.count' do
      post signup_path, params: { user: { name: "Example Name",
                                         email: "user@valid.com",
                                         password:              "foobar",
                                         password_confirmation: "foobar" } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert flash.present?
    assert is_logged_in?
  end
end
