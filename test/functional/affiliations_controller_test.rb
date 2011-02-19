require 'test_helper'

class AffiliationsControllerTest < ActionController::TestCase
  setup do
    @affiliation = affiliations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:affiliations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create affiliation" do
    assert_difference('Affiliation.count') do
      post :create, :affiliation => @affiliation.attributes
    end

    assert_redirected_to affiliation_path(assigns(:affiliation))
  end

  test "should show affiliation" do
    get :show, :id => @affiliation.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @affiliation.to_param
    assert_response :success
  end

  test "should update affiliation" do
    put :update, :id => @affiliation.to_param, :affiliation => @affiliation.attributes
    assert_redirected_to affiliation_path(assigns(:affiliation))
  end

  test "should destroy affiliation" do
    assert_difference('Affiliation.count', -1) do
      delete :destroy, :id => @affiliation.to_param
    end

    assert_redirected_to affiliations_path
  end
end
