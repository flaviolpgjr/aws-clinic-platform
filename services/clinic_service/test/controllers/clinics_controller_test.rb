require "test_helper"

class ClinicsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get clinics_index_url
    assert_response :success
  end

  test "should get show" do
    get clinics_show_url
    assert_response :success
  end

  test "should get new" do
    get clinics_new_url
    assert_response :success
  end

  test "should get edit" do
    get clinics_edit_url
    assert_response :success
  end
end
