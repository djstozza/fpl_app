require 'rails_helper'

RSpec.describe "join_leagues/show", type: :view do
  before(:each) do
    @join_league = assign(:join_league, JoinLeague.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
