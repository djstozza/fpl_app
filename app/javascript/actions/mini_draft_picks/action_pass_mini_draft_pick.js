import { PASS_MINI_DRAFT_PICK, SHOW_ERRORS } from '../types';
import axios from 'axios';

export default function passMiniDraftPick (leagueId, fplTeamListId) {
  return dispatch => {
    axios({
      method: 'post',
      url: `/leagues/${leagueId}/pass_mini_draft_picks.json`,
      data: {
        fpl_team_list_id: fplTeamListId,
        league_id: leagueId
      }
    }).then(res => {
      dispatch(passMiniDraftPickAsync(res.data));
    }).catch(error => {
      dispatch({ type: SHOW_ERRORS, payload: error.response.data });
    });
  }
}

function passMiniDraftPickAsync (data) {
  return {
    type: PASS_MINI_DRAFT_PICK,
    payload: data
  };
}
