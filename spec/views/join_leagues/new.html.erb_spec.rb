require 'rails_helper'

RSpec.describe "join_leagues/new", type: :view do
  before(:each) do
    assign(:join_league, JoinLeague.new())
  end

  it "renders new join_league form" do
    render

    assert_select "form[action=?][method=?]", join_leagues_path, "post" do
    end
  end
end
