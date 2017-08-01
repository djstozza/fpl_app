import { CREATE_WAIVER_PICK, SHOW_ERRORS } from '../types';
import axios from 'axios';

export default function createWaiverPick (fplTeamListId, listPositionId, targetId) {
  return dispatch => {
    axios({
      method: 'post',
      url: `/fpl_team_lists/${fplTeamListId}/waiver_picks.json`,
      data: {
        list_position_id: listPositionId,
        target_id: targetId
      }
    }).then(res => {
      dispatch(createWaiverPickAsync(res.data));
    }).catch(error => {
      dispatch({ type: SHOW_ERRORS, payload: error.response.data });
    });
  }
}

function createWaiverPickAsync (data) {
  return {
    type: CREATE_WAIVER_PICK,
    payload: data
  };
}
