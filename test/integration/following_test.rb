require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest

  def setup
    @user_1 = users(:test_user_1)
    @user_2 = users(:test_user_2)
    @user_3 = users(:test_user_3)
    log_in_as(@user_1)
  end

  test "following page" do
    get following_user_path(@user_1)
    assert_not @user_1.following.empty?
    assert_match @user_1.following.count.to_s, response.body
    @user_1.following.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end

  test "followers page" do
    get followers_user_path(@user_1)
    assert_not @user_1.followers.empty?
    assert_match @user_1.followers.count.to_s, response.body
    @user_1.followers.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end
end
