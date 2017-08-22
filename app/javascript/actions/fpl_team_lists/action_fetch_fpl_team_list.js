import { FETCH_FPL_TEAM_LIST } from '../types';
import axios from 'axios';

export default function fetchFplTeamLists (fplTeamId, fplTeamListId) {
  return dispatch => {
    axios.get(`/fpl_teams/${fplTeamId}/fpl_team_lists/${fplTeamListId}.json`).then(res => {
      dispatch(fetchFplTeamListsAsync(res.data));
    });
  }
}

function fetchFplTeamListsAsync (data) {
  return {
    type: FETCH_FPL_TEAM_LIST,
    payload: data
  };
}
