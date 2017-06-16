require 'rails_helper'

RSpec.describe "draft_picks/index", type: :view do
  before(:each) do
    assign(:draft_picks, [
      DraftPick.create!(),
      DraftPick.create!()
    ])
  end

  it "renders a list of draft_picks" do
    render
  end
end
