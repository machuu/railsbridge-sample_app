require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:test_user_1)
  end

  test "password_resets" do
    ## Create a new Password Reset
    get new_password_reset_path
    assert_template 'password_resets/new'

    # Invalid Email
    post password_resets_path, params: { password_reset: { email: "" } }
    assert flash.present?
    assert_template 'password_resets/new'

    # Valid Email
    post password_resets_path,
         params: { password_reset: { email: @user.email } }
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert flash.present?
    assert_redirected_to root_url

    ## Password Reset form
    user = assigns(:user)

    # Incorrect Email, Correct Token
    get edit_password_reset_path(user.reset_token, email: "" )
    assert_redirected_to root_url

    # Inactive User, Correct Email & Token
    user.toggle!(:activated)
    assert_not user.activated?
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    user.toggle!(:activated)
    assert user.activated?

    # Correct Email, Incorrect Token
    get edit_password_reset_path('wrong token', email: user.email)
    assert_redirected_to root_url

    # Correct Email, Correct Token
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", user.email

    ## Try setting new password
    # Not Matching Password & Confirmation
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              'foobaz',
                            password_confirmation: 'barquux' } }
    assert_select 'div#error_explanation'

    # Empty Password
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              '',
                            password_confirmation: '' } }
    assert_select 'div#error_explanation'

    # Valid Password & Matching Confirmation
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              'foobaz',
                            password_confirmation: 'foobaz' } }

    # Successfully Logged In
    assert is_logged_in?
    assert flash.present?
    assert_redirected_to user
  end

  test "expired token" do
    get new_password_reset_path
    post password_resets_path,
         params: { password_reset: { email: @user.email } }

    @user = assigns(:user)
    @user.update_attribute(:reset_sent_at, 3.hours.ago)
    patch password_reset_path(@user.reset_token),
          params: { email: @user.email,
                    user: { password:              'foobar',
                            password_confirmation: 'foobar' } }
    assert_response :redirect
    follow_redirect!
    assert_match /expired/i, response.body
  end
end
