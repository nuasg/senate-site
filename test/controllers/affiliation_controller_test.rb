require 'test_helper'

class AffiliationControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get affiliation_index_url
    assert_response :success
  end

  test "should get new" do
    get affiliation_new_url
    assert_response :success
  end

  test "should get create" do
    get affiliation_create_url
    assert_response :success
  end

  test "should get show" do
    get affiliation_show_url
    assert_response :success
  end

  test "should get edit" do
    get affiliation_edit_url
    assert_response :success
  end

  test "should get update" do
    get affiliation_update_url
    assert_response :success
  end

  test "should get destroy" do
    get affiliation_destroy_url
    assert_response :success
  end

end
