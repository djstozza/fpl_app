require 'rails_helper'

RSpec.describe WaiverPicksController, type: :routing do
  describe 'routing' do
    it 'only routes to #index' do
      expect(get: 'fpl_teams/1/waiver_picks').to route_to('waiver_picks#index', fpl_team_id: '1')
    end

    xit 'does not route to #new' do
      expect(get: '/fpl_teams/1/fpl_team_lists/1/waiver_picks/new').to route_to('waiver_picks#new')
    end

    xit 'only routes to #show' do
      expect(get: '/fpl_teams/1/fpl_team_lists/1/waiver_picks/1')
        .to route_to('errors#show', path: '/fpl_teams/1/fpl_team_lists/1/waiver_picks/1')
    end

    xit 'does not route to #edit' do
      expect(get: '/fpl_teams/1/fpl_team_lists/1/waiver_picks/1/edit')
        .to route_to('errors#show', path: '/fpl_teams/1/fpl_team_lists/1/waiver_picks/1/edit')
    end

    it 'only routes to #create' do
      expect(post: '/fpl_teams/1/fpl_team_lists/1/waiver_picks')
        .to route_to('waiver_picks#create', fpl_team_id: '1', fpl_team_list_id: '1')
    end

    it 'only routes to #update via PUT' do
      expect(put: '/fpl_teams/1/fpl_team_lists/1/waiver_picks/1')
        .to route_to('waiver_picks#update', id: '1', fpl_team_id: '1', fpl_team_list_id: '1')
    end

    it 'only routes to #update via PATCH' do
      expect(patch: '/fpl_teams/1/fpl_team_lists/1/waiver_picks/1')
        .to route_to('waiver_picks#update', id: '1', fpl_team_list_id: '1', fpl_team_id: '1')
    end

    it 'only routes to #destroy for fpl_team_lsits' do
      expect(delete: '/fpl_teams/1/fpl_team_lists/1/waiver_picks/1')
        .to route_to('waiver_picks#destroy', id: '1', fpl_team_id: '1', fpl_team_list_id: '1')
    end
  end
end
