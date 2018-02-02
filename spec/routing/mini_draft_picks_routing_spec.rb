require 'rails_helper'

RSpec.describe MiniDraftPicksController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: 'leagues/1/mini_draft_picks').to route_to('mini_draft_picks#index', league_id: '1')
    end

    it 'does not route to #new' do
      expect(get: 'leagues/1/mini_draft_picks/new')
        .to route_to('errors#show', path: 'leagues/1/mini_draft_picks/new')
    end

    it 'does not route to #show' do
      expect(get: 'leagues/1//mini_draft_picks/1').to route_to('errors#show', path: 'leagues/1/mini_draft_picks/1')
    end

    it 'does not route to #edit' do
      expect(get: 'leagues/1/mini_draft_picks/1/edit')
        .to route_to('errors#show', path: 'leagues/1/mini_draft_picks/1/edit')
    end

    it 'routes to #create' do
      expect(post: 'leagues/1/mini_draft_picks').to route_to('mini_draft_picks#create', league_id: '1')
    end

    it 'does not route to #update via PUT' do
      expect(put: 'leagues/1/mini_draft_picks/1').to route_to('errors#show', path: 'leagues/1/mini_draft_picks/1')
    end

    it 'does not route to #update via PATCH' do
      expect(patch: 'leagues/1/mini_draft_picks/1').to route_to('errors#show', path: 'leagues/1/mini_draft_picks/1')
    end

    it 'does not route to #destroy' do
      expect(delete: 'leagues/1/mini_draft_picks/1').to route_to('errors#show', path: 'leagues/1/mini_draft_picks/1')
    end

  end
end
