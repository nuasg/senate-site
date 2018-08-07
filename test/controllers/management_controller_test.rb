require 'test_helper'

class ManagementControllerTest < ActionDispatch::IntegrationTest
  test "should get view_roster" do
    get management_view_roster_url
    assert_response :success
  end

  test "should get update_roster" do
    get management_update_roster_url
    assert_response :success
  end

  test "should get view_terms" do
    get management_view_terms_url
    assert_response :success
  end

  test "should get update_terms" do
    get management_update_terms_url
    assert_response :success
  end

end
