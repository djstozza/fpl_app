require 'rails_helper'

RSpec.describe "inter_team_trade_groups/new", type: :view do
  before(:each) do
    assign(:inter_team_trade_group, InterTeamTradeGroup.new())
  end

  it "renders new inter_team_trade_group form" do
    render

    assert_select "form[action=?][method=?]", inter_team_trade_groups_path, "post" do
    end
  end
end
