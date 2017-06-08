require 'test_helper'

class FplTeamListsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @fpl_team_list = fpl_team_lists(:one)
  end

  test "should get index" do
    get fpl_team_lists_url
    assert_response :success
  end

  test "should get new" do
    get new_fpl_team_list_url
    assert_response :success
  end

  test "should create fpl_team_list" do
    assert_difference('FplTeamList.count') do
      post fpl_team_lists_url, params: { fpl_team_list: {  } }
    end

    assert_redirected_to fpl_team_list_url(FplTeamList.last)
  end

  test "should show fpl_team_list" do
    get fpl_team_list_url(@fpl_team_list)
    assert_response :success
  end

  test "should get edit" do
    get edit_fpl_team_list_url(@fpl_team_list)
    assert_response :success
  end

  test "should update fpl_team_list" do
    patch fpl_team_list_url(@fpl_team_list), params: { fpl_team_list: {  } }
    assert_redirected_to fpl_team_list_url(@fpl_team_list)
  end

  test "should destroy fpl_team_list" do
    assert_difference('FplTeamList.count', -1) do
      delete fpl_team_list_url(@fpl_team_list)
    end

    assert_redirected_to fpl_team_lists_url
  end
end
