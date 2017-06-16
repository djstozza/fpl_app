require 'rails_helper'

RSpec.describe "draft_picks/new", type: :view do
  before(:each) do
    assign(:draft_pick, DraftPick.new())
  end

  it "renders new draft_pick form" do
    render

    assert_select "form[action=?][method=?]", draft_picks_path, "post" do
    end
  end
end
