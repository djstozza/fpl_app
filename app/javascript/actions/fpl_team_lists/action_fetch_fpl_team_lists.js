import { FETCH_FPL_TEAM_LISTS } from '../types';
import axios from 'axios';

export default function fetchFplTeamLists (fplTeamId) {
  return dispatch => {
    axios.get(`/fpl_teams/${fplTeamId}/fpl_team_lists.json`).then(res => {
      dispatch(fetchFplTeamListsAsync(res.data));
    });
  }
}

function fetchFplTeamListsAsync (data) {
  return {
    type: FETCH_FPL_TEAM_LISTS,
    payload: data
  };
}
