import { CREATE_DRAFT_PICKS } from './types';
import axios from 'axios';

export default function createDraftPicks (leagueId) {
  return dispatch => {
    axios.post(`/leagues/${leagueId}/draft_picks.json`)
      .then(res => {
        dispatch(createDraftPicksAsync(res.data));
      });
  }
}

function createDraftPicksAsync (data) {
  return {
    type: CREATE_DRAFT_PICKS,
    payload: data
  };
}
