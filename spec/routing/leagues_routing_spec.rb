require 'rails_helper'

RSpec.describe LeaguesController, type: :routing do
  describe 'routing' do

    it 'does not route to #index' do
      expect(get: '/leagues').not_to be_routable
    end

    it 'routes to #new' do
      expect(get: '/leagues/new').to route_to('leagues#new')
    end

    it 'routes to #show' do
      expect(get: '/leagues/1').to route_to('leagues#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/leagues/1/edit').to route_to('leagues#edit', id: '1')
    end

    it 'does not route to #create' do
      expect(post: '/leagues').to route_to('leagues#create')
    end

    it 'does not route to #update via PUT' do
      expect(put: '/leagues/1').to route_to('leagues#update', id: '1')
    end

    it 'does not route to #update via PATCH' do
      expect(patch: '/leagues/1').to route_to('leagues#update', id: '1')
    end

    it 'does not route to #destroy' do
      expect(delete: '/leagues/1').not_to be_routable
    end
  end
end
