require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest

  def setup
    @user_1 = users(:test_user_1)
    @user_2 = users(:test_user_20)
    @user_3 = users(:test_user_30)
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

  test "should follow a user the standard way" do
    assert_difference '@user_1.following.count', 1 do
      post relationships_path, params: { followed_id: @user_2.id }
    end
  end

  test "should follow a user with Ajax" do
    assert_difference '@user_1.following.count', 1 do
      post relationships_path, xhr: true, params: { followed_id: @user_2.id }
    end
  end

  test "should unfollow a user the standard way" do
    @user_1.follow(@user_2)
    relationship = @user_1.active_relationships.find_by(followed_id: @user_2.id)
    assert_difference '@user_1.following.count', -1 do
      delete relationship_path(relationship)
    end
  end

  test "should unfollow a user with Ajax" do
    @user_1.follow(@user_2)
    relationship = @user_1.active_relationships.find_by(followed_id: @user_2.id)
    assert_difference '@user_1.following.count', -1 do
      delete relationship_path(relationship), xhr: true
    end
  end
end
