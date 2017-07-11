import { FETCH_TEAMS } from './types';
import axios from 'axios';

export default function fetchTeams () {
  return dispatch => {
    axios.get('/teams.json')
      .then(res => {
        dispatch(fetchTeamsAsync(res.data));
      });
  }
}

function fetchTeamsAsync (data) {
  return {
    type: FETCH_TEAMS,
    payload: data
  };
}
