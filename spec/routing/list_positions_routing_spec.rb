require 'rails_helper'

RSpec.describe ListPositionsController, type: :routing do
  describe 'routing' do
    it 'does not route to #index' do
      expect(get: '/list_positions').not_to be_routable
    end

    xit 'does not route to #new' do
      expect(get: '/list_positions/new').not_to be_routable
    end

    it 'routes to #show' do
      expect(get: '/list_positions/1').to route_to('list_positions#show', id: '1')
    end

    it 'does not route to #edit' do
      expect(get: '/list_positions/1/edit').not_to be_routable
    end

    it 'does not route to #create' do
      expect(post: '/list_positions').not_to be_routable
    end

    it 'does not route to #update via PUT' do
      expect(put: '/list_positions/1').not_to be_routable
    end

    it 'does not route to #update via PATCH' do
      expect(patch: '/list_positions/1').not_to be_routable
    end

    it 'does not route to #destroy' do
      expect(delete: '/list_positions/1').not_to be_routable
    end
  end
end
