require 'rails_helper'

RSpec.describe "JoinLeagues", type: :request do
  describe "GET /join_leagues" do
    it "works! (now write some real specs)" do
      get join_leagues_path
      expect(response).to have_http_status(200)
    end
  end
end
