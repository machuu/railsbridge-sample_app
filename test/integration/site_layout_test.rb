require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  
  test 'layout links' do
    ## Static Pages
    # Test /
    get root_path
    assert_select "title", full_title
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", help_path

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

  end
end
