require 'rails_helper'

RSpec.describe "join_leagues/edit", type: :view do
  before(:each) do
    @join_league = assign(:join_league, JoinLeague.create!())
  end

  it "renders the edit join_league form" do
    render

    assert_select "form[action=?][method=?]", join_league_path(@join_league), "post" do
    end
  end
end
