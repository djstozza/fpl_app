require 'test_helper'

class FplTeamsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @fpl_team = fpl_teams(:one)
  end

  test "should get index" do
    get fpl_teams_url
    assert_response :success
  end

  test "should get new" do
    get new_fpl_team_url
    assert_response :success
  end

  test "should create fpl_team" do
    assert_difference('FplTeam.count') do
      post fpl_teams_url, params: { fpl_team: {  } }
    end

    assert_redirected_to fpl_team_url(FplTeam.last)
  end

  test "should show fpl_team" do
    get fpl_team_url(@fpl_team)
    assert_response :success
  end

  test "should get edit" do
    get edit_fpl_team_url(@fpl_team)
    assert_response :success
  end

  test "should update fpl_team" do
    patch fpl_team_url(@fpl_team), params: { fpl_team: {  } }
    assert_redirected_to fpl_team_url(@fpl_team)
  end

  test "should destroy fpl_team" do
    assert_difference('FplTeam.count', -1) do
      delete fpl_team_url(@fpl_team)
    end

    assert_redirected_to fpl_teams_url
  end
end
