require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:test_user_1)
  end

  test 'layout links for non-logged in user' do
    ## Static Pages
    # Test /
    get root_path
    assert_select "title", full_title
    assert_template 'static_pages/home'
    assert_select "a[href=?]",    root_path, count: 2
    assert_select "a[href=?]",    about_path
    assert_select "a[href=?]",    contact_path
    assert_select "a[href=?]",    help_path
    assert_select "a[href=?]",    login_path
    assert_select "ul[class=?]", "dropdown-menu",         count: 0
    assert_select "a[href=?]",    user_path(@user),       count: 0
    assert_select "a[href=?]",    edit_user_path(@user),  count: 0
    assert_select "a[href=?]",    users_path,             count: 0
    assert_select "a[href=?]",    logout_path,            count: 0

    # Test /about
    get about_path
    assert_select "title", full_title("About")

    # Test /contact
    get contact_path
    assert_select "title", full_title("Contact")

    # Test /help
    get help_path
    assert_select "title", full_title("Help")

    ## Users Pages
    # Test /signup
    get signup_path
    assert_select "title", full_title("Sign up")

    # Test /login
    get login_path
    assert_select "title", full_title("Log in")
  end

  test 'layout links for logged in user' do
    log_in_as(@user)

    ## Static Pages
    # Test /
    get root_path
    assert_select "title", full_title
    assert_template 'static_pages/home'
    assert_select "a[href=?]",    root_path, count: 2
    assert_select "a[href=?]",    about_path
    assert_select "a[href=?]",    contact_path
    assert_select "a[href=?]",    help_path
    assert_select "a[href=?]",    login_path, count: 0
    assert_select "ul[class=?]",  "dropdown-menu"
    assert_select "a[href=?]",    user_path(@user)
    assert_select "a[href=?]",    edit_user_path(@user)
    assert_select "a[href=?]",    users_path
    assert_select "a[href=?]",    logout_path

    # Test /about
    get about_path
    assert_select "title", full_title("About")

    # Test /contact
    get contact_path
    assert_select "title", full_title("Contact")

    # Test /help
    get help_path
    assert_select "title", full_title("Help")

    ## Users Pages
    # Test /users/<id>
    get user_path(@user)
    assert_select "title", full_title("#{@user.name}")

    # Test /users/<id>/edit
    get edit_user_path(@user)
    assert_select "title", full_title("Edit user")

    # Test /users
    get users_path
    assert_select "title", full_title("All Users")
  end
end
