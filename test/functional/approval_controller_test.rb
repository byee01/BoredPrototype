require 'test_helper'

class ApprovalControllerTest < ActionController::TestCase
  test "should get approve" do
    get :approve
    assert_response :success
  end

  test "should get decline" do
    get :decline
    assert_response :success
  end

end
