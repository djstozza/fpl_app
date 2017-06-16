require 'rails_helper'

RSpec.describe "draft_picks/show", type: :view do
  before(:each) do
    @draft_pick = assign(:draft_pick, DraftPick.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
