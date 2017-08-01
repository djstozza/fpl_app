import { UPDATE_WAIVER_PICK_ORDER, SHOW_ERRORS } from '../types';
import axios from 'axios';

export default function updateWaiverPickOrder (fplTeamListId, waiverPickId, newPickNumber) {
  return dispatch => {
    axios({
      method: 'put',
      url: `/fpl_team_lists/${fplTeamListId}/waiver_picks/${waiverPickId}.json`,
      data: {
        new_pick_number: newPickNumber
      }
    }).then(res => {
      dispatch(updateWaiverPickOrderAsync(res.data));
    }).catch(error => {
      dispatch({ type: SHOW_ERRORS, payload: error.response.data });
    });
  }
}

function updateWaiverPickOrderAsync (data) {
  return {
    type: UPDATE_WAIVER_PICK_ORDER,
    payload: data
  };
}
