require 'rails_helper'

RSpec.describe "mini_draft_picks/show", type: :view do
  before(:each) do
    @mini_draft_pick = assign(:mini_draft_pick, MiniDraftPick.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
