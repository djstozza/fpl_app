require 'rails_helper'

RSpec.describe InterTeamTradeGroupsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(:get => 'fpl_teams/1/inter_team_trade_groups').to route_to(
        'inter_team_trade_groups#index', fpl_team_id: '1'
      )
    end

    it 'does not route to #new' do
      expect(:get => 'fpl_teams/1/inter_team_trade_groups/new').not_to be_routable
    end

    it 'does not route to #show' do
      expect(:get => 'fpl_teams/1/inter_team_trade_groups/1').not_to be_routable
    end

    it 'does not route to #edit' do
      expect(:get => 'fpl_teams/1/inter_team_trade_groups/1/edit').not_to be_routable
    end

    it 'routes to #create' do
      expect(:post => 'fpl_teams/1/inter_team_trade_groups').to route_to(
        'inter_team_trade_groups#create', fpl_team_id: '1'
      )
    end

    it 'routes to #update via PUT' do
      expect(:put => 'fpl_teams/1/inter_team_trade_groups/1').to route_to(
        'inter_team_trade_groups#update',  fpl_team_id: '1', id: '1'
      )
    end

    it 'routes to #update via PATCH' do
      expect(:patch => 'fpl_teams/1/inter_team_trade_groups/1').to route_to(
        'inter_team_trade_groups#update', fpl_team_id: '1', id: '1'
      )
    end

    it 'routes to #destroy' do
      expect(:delete => 'fpl_teams/1/inter_team_trade_groups/1').to route_to(
        'inter_team_trade_groups#destroy', fpl_team_id: '1', id: '1'
      )
    end
  end
end
