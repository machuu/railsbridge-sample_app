require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end

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
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?

    # Fail to log in before Activation
    log_in_as(user)
    assert_not is_logged_in?

    # Fail Activation with Incorrect Token, Correct Email
    get edit_account_activation_path("incorrect token", email: user.email)
    assert_not is_logged_in?

    # Fail Activation with Vaild Token, Incorrect Email
    get edit_account_activation_path(user.activation_token, email: 'incorrect')
    assert_not is_logged_in?

    # Succeed Activation with Vaild Token, Correct Email
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?

    # Verify Log In completed successfully
    follow_redirect!
    assert_template 'users/show'
    assert flash.present?
    assert is_logged_in?
  end
end
