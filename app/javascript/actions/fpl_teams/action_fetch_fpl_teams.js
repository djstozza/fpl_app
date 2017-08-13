import { FETCH_FPL_TEAMS } from '../types';
import axios from 'axios';

export default function fetchFplTeams () {
  return dispatch => {
    axios.get(`/fpl_teams.json`).then(res => {
      dispatch(fetchFplTeamsAsync(res.data));
    });
  }
}

function fetchFplTeamsAsync (data) {
  return {
    type: FETCH_FPL_TEAMS,
    payload: data
  };
}
