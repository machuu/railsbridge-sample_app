require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:test_user_1)
  end

  test "profile display" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_select 'h1>img.gravatar'
    assert_match @user.microposts.count.to_s, response.body
    assert_select 'div.pagination', count: 1
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
  end

  test "user info on home page" do
    ## before login
    get root_url
    assert_template 'static_pages/_home_not_logged_in'

    # no profile info
    assert_select 'img.gravatar', count: 0

    # no 'stats'
    assert_select 'section.stats>div.stats>a[href=?]', following_user_path(@user), count: 0
    assert_select 'section.stats>div.stats>a[href=?]', followers_user_path(@user), count: 0

    ## after login
    log_in_as(@user)
    get root_url
    assert_template 'static_pages/_home_logged_in'

    # User profile info
    assert_template 'shared/_user_info'
    assert_select 'section.user_info>h1', text: "#{@user.name}"
    assert_select 'img.gravatar[alt=?]', "#{@user.name}"

    # User 'stats'
    assert_template 'shared/_stats'
    assert_select 'section.stats>div.stats>a[href=?]', following_user_path(@user)
    assert_select 'section.stats>div.stats>a[href=?]', followers_user_path(@user)
  end
end
