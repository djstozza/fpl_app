require 'rails_helper'

RSpec.describe FplTeamsController, type: :routing do
  describe 'routing' do
    it 'does not route to #index' do
      expect(get: '/fpl_teams').to route_to('fpl_teams#index')
    end

    xit 'routes to #new' do
      expect(get: '/fpl_teams/new').not_to be_routable
    end

    it 'routes to #show' do
      expect(get: '/fpl_teams/1').to route_to('fpl_teams#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/fpl_teams/1/edit').to route_to('fpl_teams#edit', id: '1')
    end

    it 'does not route to #create' do
      expect(post: '/fpl_teams').not_to be_routable
    end

    it 'does not route to #update via PUT' do
      expect(put: '/fpl_teams/1').to route_to('fpl_teams#update', id: '1')
    end

    it 'does not route to #update via PATCH' do
      expect(patch: '/fpl_teams/1').to route_to('fpl_teams#update', id: '1')
    end

    it 'does not route to #destroy' do
      expect(delete: '/fpl_teams/1').not_to be_routable
    end
  end
end
