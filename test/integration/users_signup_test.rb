require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup does not create new user" do
    get signup_path
    assert_no_difference 'User.count' do
      post signup_path, params: { user: { name: "",
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
  end
end
