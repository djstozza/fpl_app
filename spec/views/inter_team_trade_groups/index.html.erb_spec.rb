require 'rails_helper'

RSpec.describe "inter_team_trade_groups/index", type: :view do
  before(:each) do
    assign(:inter_team_trade_groups, [
      InterTeamTradeGroup.create!(),
      InterTeamTradeGroup.create!()
    ])
  end

  it "renders a list of inter_team_trade_groups" do
    render
  end
end
