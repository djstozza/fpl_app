import { FETCH_WAIVER_PICKS } from '../types';
import axios from 'axios';

export default function fetchWaiverPicks (fplTeamId, roundId) {
  return dispatch => {
    axios({
      method: 'get',
      url: `/fpl_teams/${fplTeamId}/waiver_picks.json`,
      data: {
        round_id: roundId
      }
    }).then(res => {
      dispatch(fetchWaiverPicksAsync(res.data));
    });
  }
}

function fetchWaiverPicksAsync (data) {
  return {
    type: FETCH_WAIVER_PICKS,
    payload: data
  };
}
