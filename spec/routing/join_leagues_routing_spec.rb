require "rails_helper"

RSpec.describe JoinLeaguesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/join_leagues").to route_to("join_leagues#index")
    end

    it "routes to #new" do
      expect(:get => "/join_leagues/new").to route_to("join_leagues#new")
    end

    it "routes to #show" do
      expect(:get => "/join_leagues/1").to route_to("join_leagues#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/join_leagues/1/edit").to route_to("join_leagues#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/join_leagues").to route_to("join_leagues#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/join_leagues/1").to route_to("join_leagues#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/join_leagues/1").to route_to("join_leagues#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/join_leagues/1").to route_to("join_leagues#destroy", :id => "1")
    end

  end
end
