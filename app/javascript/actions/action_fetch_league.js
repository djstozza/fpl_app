import { FETCH_LEAGUE } from './types';
import axios from 'axios';

export default function fetchLeague (leagueId) {
  return dispatch => {
    axios.get(`/leagues/${leagueId}.json`)
      .then(res => {
        dispatch(fetchLeagueAsync(res.data));
      });
  }
}

function fetchLeagueAsync (data) {
  return {
    type: FETCH_LEAGUE,
    payload: data
  };
}
