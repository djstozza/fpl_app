require 'rails_helper'

RSpec.describe "inter_team_trade_groups/show", type: :view do
  before(:each) do
    @inter_team_trade_group = assign(:inter_team_trade_group, InterTeamTradeGroup.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
