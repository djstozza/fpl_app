require 'rails_helper'

RSpec.describe "mini_draft_picks/edit", type: :view do
  before(:each) do
    @mini_draft_pick = assign(:mini_draft_pick, MiniDraftPick.create!())
  end

  it "renders the edit mini_draft_pick form" do
    render

    assert_select "form[action=?][method=?]", mini_draft_pick_path(@mini_draft_pick), "post" do
    end
  end
end
