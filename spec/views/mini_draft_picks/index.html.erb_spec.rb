require 'rails_helper'

RSpec.describe "mini_draft_picks/index", type: :view do
  before(:each) do
    assign(:mini_draft_picks, [
      MiniDraftPick.create!(),
      MiniDraftPick.create!()
    ])
  end

  it "renders a list of mini_draft_picks" do
    render
  end
end
