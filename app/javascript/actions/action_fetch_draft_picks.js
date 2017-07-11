import { FETCH_DRAFT_PICKS } from './types';
import axios from 'axios';

export default function fetchDraftPicks (leagueId) {
  return dispatch => {
    axios.get(`/leagues/${leagueId}/draft_picks.json`)
      .then(res => {
        dispatch(fetchDraftPicksAsync(res.data));
      });
  }
}

function fetchDraftPicksAsync (data) {
  return {
    type: FETCH_DRAFT_PICKS,
    payload: data
  };
}
