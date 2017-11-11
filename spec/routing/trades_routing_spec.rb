require 'rails_helper'

RSpec.describe TradesController, type: :routing do
  describe 'routing' do
    it 'does not route to #index' do
      expect(get: 'fpl_teams/1/trades').not_to be_routable
    end

    it 'does not route to #new' do
      expect(get: 'fpl_teams/1/trades/new').not_to be_routable
    end

    it 'does not route to #show' do
      expect(get: 'fpl_teams/1/trades/1').not_to be_routable
    end

    it 'does not route to #edit' do
      expect(get: 'fpl_teams/1/trades/1/edit').not_to be_routable
    end

    it 'routes to #create' do
      expect(post: 'fpl_teams/1/trades').to route_to('trades#create', fpl_team_id: '1')
    end

    it 'does not route to #update via PUT' do
      expect(put: 'fpl_teams/1/trades/1').not_to be_routable
    end

    it 'does not route to #update via PATCH' do
      expect(patch: 'fpl_teams/1/trades/1').not_to be_routable
    end

    it 'does not route to #destroy' do
      expect(delete:'fpl_teams/1/trades/1').not_to be_routable
    end
  end
end
