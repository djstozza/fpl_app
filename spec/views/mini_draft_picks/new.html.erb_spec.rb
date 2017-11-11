require 'rails_helper'

RSpec.describe "mini_draft_picks/new", type: :view do
  before(:each) do
    assign(:mini_draft_pick, MiniDraftPick.new())
  end

  it "renders new mini_draft_pick form" do
    render

    assert_select "form[action=?][method=?]", mini_draft_picks_path, "post" do
    end
  end
end
