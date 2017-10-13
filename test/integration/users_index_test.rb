require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:test_admin_1)
    @user = users(:test_user_1)
  end

  test "index includes pagination, but not delete links, when logged in as non-admin" do
    log_in_as(@user)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination', count: 2
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
    end
    assert_select 'a', text: 'delete', count: 0
  end

  test "index includes pagination and delete links when logged in as admin" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination', count: 2
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end
  end

  test "non-admin index does not display unactivated users" do
    log_in_as(@user)

    # pagination uses default User order
    # so grab a low number to ensure it's on the first page
    @deactivate_user = User.fourth

    # Check that activated user is displayed
    get users_path
    assert_template 'users/index'
    assert_select 'a[href=?]', user_path(@deactivate_user), text: @deactivate_user.name

    # Mark second user as not activated
    @deactivate_user.update_attribute(:activated, false)

    # Check that de-activated user is not displayed
    get users_path
    assert_template 'users/index'
    assert_select 'a[href=?]', user_path(@deactivate_user), count: 0
  end
end
