require 'rails_helper'

RSpec.describe FplTeamsController, type: :routing do
  describe 'routing' do
    it 'does not route to #index' do
      expect(get: '/fpl_teams/1/fpl_team_lists').to route_to('fpl_team_lists#index', fpl_team_id: '1')
    end

    xit 'routes to #new' do
      expect(get: '/fpl_teams/1/fpl_team_lists/new').not_to be_routable
    end

    it 'routes to #show' do
      expect(get: '/fpl_teams/1/fpl_team_lists/1').to route_to('fpl_team_lists#show', fpl_team_id: '1', id: '1')
    end

    it 'does not route to #edit' do
      expect(get: '/fpl_teams/1/fpl_team_lists/1/edit').not_to be_routable
    end

    it 'does not route to #create' do
      expect(post: '/fpl_teams/1/fpl_team_lists').not_to be_routable
    end

    it 'does not route to #update via PUT' do
      expect(put: '/fpl_teams/1/fpl_team_lists/1').to route_to('fpl_team_lists#update', fpl_team_id: '1', id: '1')
    end

    it 'does not route to #update via PATCH' do
      expect(patch: '/fpl_teams/1/fpl_team_lists/1').to route_to('fpl_team_lists#update', fpl_team_id: '1', id: '1')
    end

    it 'does not route to #destroy' do
      expect(delete: '/fpl_teams/1/fpl_team_lists/1').not_to be_routable
    end
  end
end
