import { DELETE_WAIVER_PICK, SHOW_ERRORS } from '../types';
import axios from 'axios';

export default function deleteWaiverPick (fplTeamId, fplTeamListId, waiverPickId) {
  return dispatch => {
    axios({
      method: 'delete',
      url: `/fpl_teams/${fplTeamId}/fpl_team_lists/${fplTeamListId}/waiver_picks/${waiverPickId}.json`
    }).then(res => {
      dispatch(deleteWaiverPickAsync(res.data));
    }).catch(error => {
      dispatch({ type: SHOW_ERRORS, payload: error.response.data });
    });
  }
}

function deleteWaiverPickAsync (data) {
  return {
    type: DELETE_WAIVER_PICK,
    payload: data
  };
}
