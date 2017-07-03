import { FETCH_FPL_TEAM } from './types';
import axios from 'axios';

export default function fetchFplTeam(fplTeamId) {
  return dispatch => {
    axios.get(`/fpl_teams/${fplTeamId}.json`)
      .then(res => {
        dispatch(fetchFplTeamAsync(res.data));
      });
  }
}

function fetchFplTeamAsync(data){
  return {
    type: FETCH_FPL_TEAM,
    payload: data
  };
}
