# frozen_string_literal: true

require "test_helper"

class FavoritesControllerTest < ActionDispatch::IntegrationTest
  test "should get favorite" do
    get favorites_favorite_url
    assert_response :success
  end

  test "should get unfavorite" do
    get favorites_unfavorite_url
    assert_response :success
  end
end
