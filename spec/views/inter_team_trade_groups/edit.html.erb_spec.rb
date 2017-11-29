require 'rails_helper'

RSpec.describe "inter_team_trade_groups/edit", type: :view do
  before(:each) do
    @inter_team_trade_group = assign(:inter_team_trade_group, InterTeamTradeGroup.create!())
  end

  it "renders the edit inter_team_trade_group form" do
    render

    assert_select "form[action=?][method=?]", inter_team_trade_group_path(@inter_team_trade_group), "post" do
    end
  end
end
