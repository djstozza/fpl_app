import { FETCH_MINI_DRAFT_PICKS } from '../types';
import axios from 'axios';

export default function fetchMiniDraftPicks (leagueId, roundId) {
  return dispatch => {
    axios.get(`/leagues/${leagueId}/mini_draft_picks.json`, {
      params: {
        round_id: roundId
      }
    }).then(res => {
      dispatch(fetchMiniDraftPicksAsync(res.data));
    });
  }
}

function fetchMiniDraftPicksAsync(data) {
  return {
    type: FETCH_MINI_DRAFT_PICKS,
    payload: data
  };
}
