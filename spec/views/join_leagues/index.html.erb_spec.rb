require 'rails_helper'

RSpec.describe "join_leagues/index", type: :view do
  before(:each) do
    assign(:join_leagues, [
      JoinLeague.create!(),
      JoinLeague.create!()
    ])
  end

  it "renders a list of join_leagues" do
    render
  end
end
