import { UPDATE_FPL_TEAM_LIST } from '../types';
import axios from 'axios';

export default function updatehFplTeamList (fplTeamId, fplTeamListId, playerId, targetId) {
  return dispatch => {
    axios({
      method: 'put',
      url: `/fpl_teams/${fplTeamId}/fpl_team_lists/${fplTeamListId}.json`,
      data: {
        player_id: playerId,
        target_id: targetId
      }
    }).then(res => {
      dispatch(updateFplTeamListAsync(res.data));
    });
  }
}

function updateFplTeamListAsync (data) {
  return {
    type: UPDATE_FPL_TEAM_LIST,
    payload: data
  };
}
