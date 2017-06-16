require 'rails_helper'

RSpec.describe "draft_picks/edit", type: :view do
  before(:each) do
    @draft_pick = assign(:draft_pick, DraftPick.create!())
  end

  it "renders the edit draft_pick form" do
    render

    assert_select "form[action=?][method=?]", draft_pick_path(@draft_pick), "post" do
    end
  end
end
