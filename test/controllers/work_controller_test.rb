require "test_helper"

class WorkControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get work_index_url
    assert_response :success
  end

  test "should get choose_theme" do
    get work_choose_theme_url
    assert_response :success
  end

  test "should get display_theme" do
    get work_display_theme_url
    assert_response :success
  end
end
