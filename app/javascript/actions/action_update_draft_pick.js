import { UPDATE_DRAFT_PICK, SHOW_ERRORS } from './types';
import axios from 'axios';

export default function updateDraftPick(leagueId, draftPickId, playerId) {
  return dispatch => {
    axios({
      method: 'put',
      url: `/leagues/${leagueId}/draft_picks/${draftPickId}.json`,
      data: {
        player_id: playerId
      }
    }).then(res => {
      dispatch(updateDraftPickAsync(res.data));
    }).catch(error => {
      dispatch({type: SHOW_ERRORS, payload: error.response.data});
    });
  }
}

function updateDraftPickAsync(data){
  return {
    type: UPDATE_DRAFT_PICK,
    payload: data
  };
}
