import { CREATE_MINI_DRAFT_PICK, SHOW_ERRORS } from '../types';
import axios from 'axios';

export default function createMiniDraftPick (leagueId, fplTeamListId, listPositionId, playerId) {
  return dispatch => {
    axios({
      method: 'post',
      url: `/leagues/${leagueId}/mini_draft_picks.json`,
      data: {
        player_id: playerId,
        fpl_team_list_id: fplTeamListId,
        list_position_id: listPositionId,
        league_id: leagueId
      }
    }).then(res => {
      dispatch(createMiniDraftPickAsync(res.data));
    }).catch(error => {
      dispatch({ type: SHOW_ERRORS, payload: error.response.data });
    });
  }
}

function createMiniDraftPickAsync (data) {
  return {
    type: CREATE_MINI_DRAFT_PICK,
    payload: data
  };
}
