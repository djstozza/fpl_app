require 'rails_helper'

RSpec.describe "trades/index", type: :view do
  before(:each) do
    assign(:trades, [
      Trade.create!(),
      Trade.create!()
    ])
  end

  it "renders a list of trades" do
    render
  end
end
