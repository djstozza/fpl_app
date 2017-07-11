import { FETCH_TEAM } from './types';
import axios from 'axios';

export default function fetchTeam (teamId) {
  return dispatch => {
    axios.get(`/teams/${teamId}.json`)
      .then(res => {
        dispatch(fetchTeamAsync(res.data));
      });
  }
}

function fetchTeamAsync (data) {
  return {
    type: FETCH_TEAM,
    payload: data
  };
}
